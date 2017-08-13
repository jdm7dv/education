/* onefrand.c	1.2	(CARL)	9/19/86	14:57:14 */

/*
 * 1/f noise according to Voss' algorithm. Sequence length (seq) may be any
 * number, but is truncated to the nearest power of 2. The algorithm: Select
 * log2(sequence) separate white noise generators, i.e., one for each bit of
 * a binary number. Initialize a counting register. In a loop, add 1 to the
 * counting register, determine which bits have changed from its previous
 * value.  For each changed bit, invoke the appropriate generator to produce
 * a new number. Sum the normalized output of all generators as the current
 * number. The procedure f1init() is used to reset the sequence length. On
 * the next call to onefrand(), the new value of seq will be used. 
 */

#include<math.h>
#include<stdio.h>
#include<stdlib.h>

static          f1ini;

double 
onefrand(lb, ub, seq)
	double          lb, ub;
	int             seq;
{
	double          tmp;
	register int    i, dif;
	static int      gens;
	static double  *sums;
	double          sum;
	static double   div;
	static int      cnt = -1, ocnt;

	if (f1ini == 0) {
		register double dseq = seq;
		f1ini++;
		if (dseq <= 1)
			dseq = 2;
		gens = log(dseq) / log(2.0);
		if (sums != NULL)
			free(sums);
		sums = (double *) malloc(sizeof(double) * gens);
		for (i = 0; i < gens; i++)
			sums[i] = 0;
		div = pow(2.0, 31.0) - (double) 1.0;
	}
	ocnt = cnt++;		/* increment count */
	dif = cnt ^ ocnt;	/* set sums to change */

	for (i = 0; i < gens; i++) {	/* form new sums */
		if (dif & (1 << i))
			sums[i] = random();
	}

	for (sum = i = 0; i < gens; i++)	/* sum them all */
		sum += sums[i];

	sum /= gens * div;
	sum = (sum * (ub - lb)) + lb;	/* norm to spec */
	return (sum);
}

f1init()
{
	f1ini = 0;
}
