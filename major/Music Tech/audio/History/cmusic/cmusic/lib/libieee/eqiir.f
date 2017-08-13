c
c-----------------------------------------------------------------------
c subroutine:   defin0
c definition of the machine parameters
c-----------------------------------------------------------------------
c
      subroutine defin0
c
      double precision dpi, domi
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /const/ pi, flma, flmi, fler
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /const2/ dpi, domi
      common /ciofor/ iofo(3), ion
c
      dimension jofo(3)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      data jofo /2h(4,2h0a,2h2)/, jon /40/
c
c this statement is written for the pdp11/45 and is
c machine dependent (see manual 4.2.2.)
c e.g.:   cdc cyber 172
c data iofo /10h(8a10)    ,2*10h          /,ion/8/
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      ka1 = i1mach(1)
      ka2 = i1mach(2)
      ka3 = 6
      ka4 = 1
      ka5 = 9
      line = 65
c
      pi = 4.*atan(1.0)
      flma = 2.**(i1mach(13)-2)
      flmi = r1mach(3)
      fler = 1.0e02*flmi
c
      dpi = 4.00*datan(1.0d00)
      domi = d1mach(3)
c
      maxdeg = 32
      iwlmi = 2
      iwlma = i1mach(11)
      mbl = 16
c
      iofo(1) = jofo(1)
      iofo(2) = jofo(2)
      iofo(3) = jofo(3)
      ion = jon
c
      return
c
      end
c
c ======================================================================
c
c doredi - subroutines:  root elements for overlays
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   synthe
c subroutine to handle the necessary commons for synnor and synopt
c for overlays
c-----------------------------------------------------------------------
c
      subroutine synthe
c
      double precision dk, dks, dcap02, dcap04
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /tolnor/ vsnn, ndegn, nbn
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /resin2/ dk, dks, dcap02, dcap04
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      call synnor
      if (loptw.eq.0) return
      call synopt
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   synnor
c synthesis of recursive digital filters
c calculation of the zeros and the poles
c-----------------------------------------------------------------------
c
      subroutine synnor
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /outdat/ ip, pre, pim, iz, zre, zim
c
      mout = nout
      if (iprun.eq.(-3)) nout = 0
      call desia
      nout = mout
      if (loptw.ne.0) return
      call desib
      if (ndout.eq.(-1)) call out012
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   synopt
c synthesis of recursive digital filters with optimized coefficients
c calculation of the poles and the optimization parameter
c-----------------------------------------------------------------------
c
      subroutine synopt
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /const/ pi, flma, flmi, fler
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /coptcp/ is1, is2, iabo, iwlgs, iwlgn, iwlgp, adepss,
     *    adepsn, adepsp, acxs, acxn, acxp
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      flab = 10.*flmi
      acxn = acxmi
      acxp = acxma
      adepss = flma
      adepsp = flma
      adepsn = -flma
      iter = 0
      iwlgs = iwlma
      iwlgp = iwlma
      iwlgn = iwlma
      iwll = iwlma
      idepsl = 0
      is1 = 0
      is2 = 0
      iabo = 0
      iterm2 = iterm
      if (iprun.eq.3 .and. jstru.eq.1) iterm = iterm1
      mout = nout
      if (nout.le.3) nout = nout - 2
c
  10  iter = iter + 1
      if (iprun.eq.(-3)) call blnumz
      if (nout.ge.2) call out023
      call desib
      if (iter.gt.1) go to 20
      call grid01
      call grid04
      if (nout.eq.5) call out042
      acxs = acx
  20  if (loptw.eq.0) go to 60
      call coefw
      call copy02
      call optpar
      if (nout.ge.2) call out045
      if (iter.ge.iterm) go to 30
      if (acx-acxmi.lt.flab) go to 40
      if (acxma-acx.lt.flab) go to 40
      if (iabo.lt.3) go to 10
      iabo = 1
      go to 50
  30  iabo = 2
      go to 50
  40  iabo = 3
  50  nout = mout
      if (nout.ge.1) call out022
      acx = acxs
      if (iprun.eq.3 .and. jstru.eq.1) go to 80
      if (iprun.eq.(-3)) call blnumz
      call desib
      if (nout.eq.1) call out011
      if (nout.eq.2) call out038
  60  if (nout/2.eq.1) call out039
      iwl = iwlgs
      if (iprun.eq.3 .and. jstrus.eq.1) go to 70
      if (ndout.eq.(-1)) call out012
  70  loptw = 1
      mout = nout
      if (nout.ne.0) nout = nout + 2
      call coefw
      if (iprun.ne.(-3)) call copy02
      nout = mout
  80  iterm = iterm2
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   seqsta
c start noise analysis and optimization
c-----------------------------------------------------------------------
c
      subroutine seqsta
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /coptst/ lopts, istor
c
      if (lseq.ne.(-1)) go to 10
      if (nout.ge.3) call out011
      call copy01
      call allo02
      go to 20
c
  10  if (ninp.ge.3 .and. lopts.eq.1) call fixpar
  20  l = lstab
      lstab = 0
      call stable
      if (istab.ne.(-1)) go to 50
      lstab = l
      if (istru.ge.30) go to 30
      call tstr01
      go to 40
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert tests for your own structure implementations
c
  30  call error(8)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
  40  if (iwlr.eq.100) return
      if (iwlr.gt.iwlma) return
      l = iwl
      iwl = iwlr
      call reco
      call round(1, 5)
      call stable
      iwl = l
      return
  50  call error(30)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   seqopt
c optimization of the pairing and ordering of the second-order blocks
c optimization procedure with limited storage
c-----------------------------------------------------------------------
c
      subroutine seqopt
c
      complex zp, zps
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /coptst/ lopts, istor
      common /cgrid/ gr(64), ngr(12)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /cpol/ zp(16,2), zps(16,2)
      common /cnoise/ ri, rin, re, ren, fac
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cpow/ pnu, pnc, and, itcorp
c
      if (iscal.eq.0) go to 10
      call descal
  10  call copy01
      if (nout.ge.3) call out011
      call polloc
      if (ngr(8).eq.0) call grid02
      if (nout.ge.5) call out042
      if (nout.ge.3) call out025
      if (lopts.ne.0) call optlst
      call ananoi
      if (nout.eq.0) return
      call out027
      if (nout.eq.1) return
      if (jstrus.eq.2) call out010
      call out011
      if (jstrus.eq.2) call denorm
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   analys
c analysis of the designed recursive digital filter
c-----------------------------------------------------------------------
c
      subroutine analys
c
      complex zp, zps
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptst/ lopts, istor
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /cpol/ zp(16,2), zps(16,2)
      common /cnoise/ ri, rin, re, ren, fac
c
      call anal01
      if (lopts.eq.0) go to 10
      call anal02
  10  if (iplot.eq.0) go to 20
      call plot00
c
  20  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   anal01
c first part of analysis
c-----------------------------------------------------------------------
c
      subroutine anal01
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptst/ lopts, istor
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /cgrid/ gr(64), ngr(12)
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      if (lseq.ne.(-1)) go to 10
      if (nout.ge.3) call out011
      call copy01
      call allo02
c
  10  l = lstab
      lstab = 0
      call stable
      if (istab.ne.(-1)) go to 50
      lstab = l
      if (loptw.eq.0) go to 30
      if (ngr(1).ne.0) go to 20
      if (ninp.ge.3) call grid03
      call grid01
      if (ninp.le.2) call grid04
  20  if (nout.eq.5) call out042
      call coefw
      call copy02
      loptw = 0
  30  if (lopts.ne.(-1) .and. iplot.eq.0) go to 60
      if (iwlr.eq.100) go to 60
      iwl = iwlr
      if (iwl.gt.iwlma) go to 40
      call reco
      call round(1, 5)
      call stable
      go to 60
  40  call error(16)
      go to 60
  50  call error(30)
  60  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   anal02
c second part of the analysis
c-----------------------------------------------------------------------
c
      subroutine anal02
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /coptst/ lopts, istor
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /cnoise/ ri, rin, re, ren, fac
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cpow/ pnu, pnc, and, itcorp
c
      if (istru.ge.30) go to 10
      call tstr01
      go to 20
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert tests for your own structure implementations
c
  10  call error(8)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
  20  if (iscal.ne.0) call descal
      call copy01
      if (nout.ge.3) call out011
      lopts = 0
      call polloc
      call grid02
      if (nout.ge.3) call out025
      call ananoi
      call out027
      if (jstrus.eq.2) call out010
      call out011
      if (jstrus.eq.2) call denorm
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   plot00
c printer plots
c-----------------------------------------------------------------------
c
      subroutine plot00
c
      common /const/ pi, flma, flmi, fler
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /cstatv/ x1(16), x2(16)
      common /cline/ y, x, iz(111)
c
      dimension a(6)
      equivalence (a(1),iz(1))
c
      data ichi, ichp, ichc, ichm, ichb /1hi,1h+,1h.,1h-,1h /
c
c number of printed lines
c
      if (iplot.gt.4) go to 230
      ml = ipag*line - 6
      adom = (omup-omlo)/float(ml-1)
c
c scaling
c
      if (lnor.ne.(-1)) go to 60
c
      rrmax = -flma
      rrmin = flma
c
      if (iplot.eq.4) y = resp(1.,1)
      do 30 l=1,ml
        if (iplot.eq.4) go to 20
        x = adom*float(l-1) + omlo
        if (iplot.eq.3) go to 10
        y = amago(x)
        if (iplot.eq.1) go to 20
        if (y.lt.flmi) y = flmi
        y = -20.*alog10(y)
        if (y.gt.rmax) y = rmax
        go to 20
  10    y = phase(x)
  20    rrmax = amax1(rrmax,y)
        rrmin = amin1(rrmin,y)
        if (iplot.ne.4) go to 30
        y = resp(0.,0)
  30  continue
c
c scaling of the plots
c
      rr = abs(rrmax-rrmin)
      rn = 0.005*rr
      rrmax = rrmax - rn
      rrmin = rrmin + rn
      rr = abs(rrmax-rrmin)
      if (rr.le.0.) rr = abs(rrmax)
      iq = int(alog10(rr))
      rn = 10.**float(iq)
      if (rn.lt.rr) rn = rn*10.
      an = rr/rn
      if (an.gt.0.0) aan = 0.1
      if (an.gt.0.1) aan = 0.2
      if (an.gt.0.2) aan = 0.5
      if (an.gt.0.5) aan = 1.0
      rr = aan*rn
c
  40  rn = rr*0.2
      rma = aint(rrmax/rn)*rn
      if (rma.lt.rrmax) rma = rma + rn
      rmi = rma - rr
      if (rmi.le.rrmin) go to 50
      rmi = aint(rrmin/rn)*rn
      if (rmi.gt.rrmin) rmi = rmi - rn
      rma = rmi + rr
      if (rma.ge.rrmax) go to 50
      rr = rr*2.
      if (aan.eq.0.2) rr = rr*1.25
      go to 40
c
  50  rrmax = rma
      rrmin = rmi
      go to 110
c
  60  go to (70, 70, 80, 90), iplot
  70  rrmax = rmax
      rrmin = 0.
      go to 100
  80  rrmax = pi
      rrmin = -rrmax
      go to 100
  90  rrmax = rmax
      rrmin = rmin
 100  rr = rrmax - rrmin
c
 110  call out060
      null = int(-rrmin*100./rr+1.5)
      if (null.lt.1 .or. null.gt.111) null = 0
      q = rr/5.
      do 120 i=1,6
        a(i) = q*float(i-1) + rrmin
 120  continue
      call out061
      do 130 i=1,111
        iz(i) = ichm
 130  continue
      if (iplot.eq.4) y = resp(1.,1)
      x = 1.
      do 220 l=1,ml
        if (iplot.eq.4) go to 150
        x = adom*float(l-1) + omlo
        if (iplot.eq.3) go to 140
        y = amago(x)
        if (iplot.ne.2) go to 150
        if (y.lt.flmi) y = flmi
        y = -20.*alog10(y)
        go to 150
 140    y = phase(x)
 150    do 160 i=1,101,10
          iz(i) = ichc
 160    continue
        if (null.ne.0) iz(null) = ichc
        y1 = (y-rrmin)/rr
        iy = int(100.*y1+1.5)
        if (iy.gt.0) go to 170
        iz(1) = ichi
        go to 190
 170    if (iy.le.111) go to 180
        iz(111) = ichi
        go to 190
 180    iz(iy) = ichp
 190    call out062
        if (iplot.ne.4) go to 200
        y = resp(0.,0)
        x = float(l)
 200    do 210 i=1,111
          iz(i) = ichb
 210    continue
 220  continue
      go to 240
 230  call error(8)
 240  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   dorinp
c input data compiler for the design program 'doredi'
c-----------------------------------------------------------------------
c
      subroutine dorinp
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /intdat/ jinp(16)
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /coptst/ lopts, istor
c
      dimension ipt1(5), ipt2(5)
      data ipt1(1), ipt1(2), ipt1(3), ipt1(4), ipt1(5) /1hs,1hs,1hs,1ha,
     *    1hf/
      data ipt2(1), ipt2(2), ipt2(3), ipt2(4), ipt2(5) /1hy,1he,1hs,1hn,
     *    1hi/
      data ipmax /5/
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert your own program definitions
c change dimension and data statement in front
c 'fi' has to be last definition
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      lcode = -1
      if (iplot.ne.0) go to 50
      if (ipcon.ne.0) go to 10
      call defin1
      call defin2
      call defin3
      call defin4
      call defin5
      call defin6
      go to 60
c
  10  if (ipcon.eq.99) stop
      iprun = ipcon
      if (ipcon.eq.4) go to 40
      call defin2
      if (ipcon.eq.2) go to 20
      call defin3
      call defin4
      if (ipcon.eq.1) go to 60
  20  call defin5
  30  if (iprun.eq.2 .or. iprun.eq.3) lopts = -1
      if (iprun.eq.3) loptw = -1
      go to 60
  40  call defin6
      go to 60
c
  50  iplot = 0
  60  call inp001
      if (lcode.eq.0) go to 110
  70  do 80 ip=1,ipmax
        if (icode.eq.ipt1(ip) .and. jcode.eq.ipt2(ip)) go to 90
  80  continue
      go to 190
  90  if (iprun.eq.0) go to 100
      if (ip.eq.ipmax) ip = 99
      ipcon = ip
      if (iprun.eq.1 .or. iprun.eq.3) call inp031
      return
c
 100  iprun = ip
      go to 30
c
 110  if (iprun.eq.0) go to 190
      call inp002
      if (icode.eq.0) go to 210
      go to (120, 130, 140, 150, 160, 170), icode
 120  call inp010
      go to 180
 130  if (iprun.ge.4) go to 200
      call inp020
      go to 60
 140  if (iprun.eq.2) go to 200
      call inp030
      go to 60
 150  call inp040
      go to 180
 160  if (iprun.le.1) go to 200
      call inp050
      go to 180
 170  if (iprun.ne.4) go to 200
      call inp060
      if (iplot.eq.0) go to 60
      return
c
 180  if (lcode.ne.0) go to 70
      go to 60
c
 190  i = 3
      go to 220
 200  i = 4
      go to 220
 210  i = 2
 220  call error(i)
      go to 60
      end
c
c ======================================================================
c
c doredi - subroutines: part i
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   desia
c filter design -- first section
c-----------------------------------------------------------------------
c
      subroutine desia
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /tolnor/ vsnn, ndegn, nbn
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /outdat/ ip, pre, pim, iz, zre, zim
c
      sfa = 0.
      if (nout.ge.3) call out030
      call desi00
      if (nout.ge.4) call out031
      call desi01
      if (nout.ge.3) call out033
      go to (10, 20, 20, 30), iapro
  10  call desi11
      go to 40
  20  call desi12
      go to 40
  30  call desi14
c
  40  vsnn = vsn
      ndegn = ndeg
      nbn = nj
      if (nout.ge.5) call out034
      if (nout.ge.3) call out035
      if (nout.lt.4) go to 50
      iz = 0
      ip = 0
      call out036
  50  call tranze
      if (nout.lt.4) go to 60
      iz = 1
      ip = 0
      call out036
  60  call trbize
      call blnumz
      call romeg
      if (nout.ge.3) call out032
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desib
c filter design  --  second section
c-----------------------------------------------------------------------
c
      subroutine desib
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolnor/ vsnn, ndegn, nbn
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      vsn = vsnn
      ndeg = ndegn
      nj = nbn
      go to (10, 20, 20, 30), iapro
  10  call desi21
      go to 40
  20  call desi22
      go to 40
  30  call desi24
c
  40  if (nout.ge.3) call out037
      if (nout.lt.4) go to 50
      iz = 0
      ip = 1
      call out036
  50  call tranpo
      if (lsout.eq.(-1)) go to 60
      if (nout.lt.4) go to 70
  60  iz = 1
      ip = 1
      call out036
      if (lsout.eq.(-1)) call out016
  70  call trbipo
      if (nout.ge.3) call out038
      call bldenz
      if (nout.ge.2) call out011
      if (nout.ge.4) call out039
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi00
c transform tolerance scheme
c-----------------------------------------------------------------------
c
      subroutine desi00
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      if (ityp.ge.3) ndeg = (ndeg+1)/2
      if (ndeg.ne.0) adeg = float(ndeg)/(1.+edeg)
      if (lvsn.lt.0) go to 20
      if (lvsn.eq.0) go to 10
      call parcha
      call vsnmax
  10  call transn
  20  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi01
c design of butterworth, chebyshev (passband or stopband), and
c elliptic filters
c-----------------------------------------------------------------------
c
      subroutine desi01
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      if (lvsn.ne.0) go to 20
      call parcha
      call degree
      q = adeg*(1.+edeg) + 0.5
      n = int(q)
      m = int(adeg)
      if (float(m).lt.adeg) m = m + 1
      n = max0(m,n)
      if (ndeg.eq.0) go to 10
      if (ndeg.ge.n) go to 20
      call error(15)
      if (ndegf.eq.(-1)) stop
c
  10  ndeg = n
c
  20  if (ndeg.le.maxdeg) return
      call error(25)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   parcha
c computation of the parameters of the characteristic function
c-----------------------------------------------------------------------
c
      subroutine parcha
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      gd1 = 0.
      gd2 = -1.
      if (adelp.gt.0.) gd1 = sqrt((2.-adelp)*adelp)/(1.-adelp)
      if (adels.gt.0.) gd2 = sqrt(1.-adels*adels)/adels
      acap12 = gd1/gd2
      if (acap12.gt.0.) go to 60
      go to (10, 20, 20, 30), iapro
  10  acap12 = vsn**(-adeg)
      go to 40
  20  q = arcosh(vsn)*adeg
      acap12 = 1./cosh(q)
      go to 40
  30  call bound
  40  if (gd2.eq.(-1.)) go to 50
      gd1 = acap12*gd2
      adelp = 1. - 1./sqrt(1.+gd1*gd1)
      go to 60
  50  gd2 = gd1/acap12
      adels = 1./sqrt(1.+gd2*gd2)
  60  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   vsnmax
c computation of the normalized cutoff frequency for a filter
c degree and the ripples given
c-----------------------------------------------------------------------
c
      subroutine vsnmax
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
c
      ac = 1./acap12
      e = 1./adeg
      go to (10, 20, 20, 30), iapro
  10  vsn = ac**e
      go to 40
  20  vsn = cosh(e*arcosh(ac))
      go to 40
  30  call bound
  40  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   bound
c calculation of a bound for vsn or acap12 for elliptic filters
c-----------------------------------------------------------------------
c
      subroutine bound
c
      double precision dpi, domi
      double precision de, dkk, ddeg, dcap12, deg, dcap14, dq, dk1,
     *    dab, dmax, dde
      double precision dk, df, dd
      double precision dff, dellk
c
      common /const2/ dpi, domi
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
c
      dimension dk(3), df(3)
c
      data de /1.d00/
      dff(dd) = (dellk(dd)*dkk/dellk(dsqrt(de-dd*dd)))**ii - ddeg
      if (acap12.le.0.) go to 10
      dcap12 = dble(acap12)
      deg = dble(1./adeg)
      ii = 1
      go to 20
  10  dcap12 = de/dble(vsn)
      deg = dble(adeg)
      ii = -1
  20  dcap14 = dsqrt(de-dcap12*dcap12)
      dkk = dellk(dcap14)/dellk(dcap12)
      dq = dexp(-dpi*dkk*deg)
      dk1 = 4.d00*dsqrt(dq)
      if (dk1.lt.de) go to 30
      dq = 2.d00*dq
      dq = (de-dq)/(de+dq)
      dq = dq*dq
      dk1 = dsqrt(de-dq*dq)
  30  dk(1) = dk1
      dk(2) = (de+dk(1))/2.d00
      ddeg = dble(adeg)
      df(1) = dff(dk(1))
      df(2) = dff(dk(2))
  40  dk(3) = dk(1) - df(1)*(dk(1)-dk(2))/(df(1)-df(2))
      df(3) = dff(dk(3))
      if (dabs(df(3)).lt.1.d-6) go to 60
      dmax = 0.d00
      do 50 j=1,3
        dab = dabs(df(j))
        if (dmax.gt.dab) go to 50
        jj = j
        dmax = dab
  50  continue
      if (jj.eq.3) go to 40
      dk(jj) = dk(3)
      df(jj) = df(3)
      go to 40
  60  if (acap12.le.0.) go to 70
      dde = de/dk(3)
      vsn = sngl(dde)
      return
  70  acap12 = sngl(dk(3))
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   degree
c computation of the minimum filter degree (adeg)
c-----------------------------------------------------------------------
c
      subroutine degree
c
      double precision de, dcap02, dcap04, dcap12, dcap14, dadeg
      double precision dellk
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
c
      go to (10, 20, 20, 30), iapro
c
  10  adeg = alog(1./acap12)/alog(vsn)
      return
c
  20  adeg = arcosh(1./acap12)/arcosh(vsn)
      return
c
  30  de = 1.d00
      dcap02 = de/dble(vsn)
      dcap04 = dsqrt(de-dcap02*dcap02)
      dcap12 = dble(acap12)
      dcap14 = dsqrt(de-dcap12*dcap12)
      dadeg = (dellk(dcap02)*dellk(dcap14))/(dellk(dcap04)*dellk(dcap12)
     *    )
      adeg = sngl(dadeg)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi11
c butterworth filter
c computation of the zeros and locations of the extrema
c-----------------------------------------------------------------------
c
      subroutine desi11
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      adelta = vsn**ndeg
c
      nh = ndeg/2
      nj = (ndeg+1)/2
      fdeg = float(ndeg)
      fn = pi/2./fdeg
c
      do 10 i=1,nj
        nzero(i) = 0
        iii = i + i - 1
        q = fn*float(iii)
        pren(i) = sin(q)
        pimn(i) = cos(q)
  10  continue
c
      fn = 2.*fn
      nzero(1) = ndeg
      nzm(1) = 1
      sm(1,1) = 0.
      nzm(2) = 1
      sm(1,2) = 1.
      nzm(3) = 1
      sm(1,3) = vsn
      nzm(4) = 1
      sm(1,4) = flma
c
      ugc = gd2/adelta
      ogc = gd1
      sm(17,4) = 1.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi12
c chebyshev filter (passband or stopband)
c computation of the zeros and the locations of the extrema
c-----------------------------------------------------------------------
c
      subroutine desi12
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      adelta = cosh(float(ndeg)*arcosh(vsn))
c
      fa = 1.
      nh = ndeg/2
      nj = (ndeg+1)/2
      fn = pi/(2.*float(ndeg))
c
      do 10 i=1,nj
        nzero(i) = 0
        inj = i + i - 1
        q = fn*float(inj)
        pren(i) = sin(q)
        pimn(i) = cos(q)
  10  continue
c
      fn = 2.*fn
c
      if (iapro.eq.3) go to 40
c
      m = nj + 1
      do 20 i=1,nj
        j = m - i
        sm(i,1) = pimn(j)
  20  continue
      nzm(1) = nj
      m = nh + 1
      do 30 i=1,m
        mi = m - i
        q = float(mi)*fn
        sm(i,2) = cos(q)
  30  continue
      nzm(2) = m
      sm(1,3) = vsn
      nzm(3) = 1
      sm(1,4) = flma
      nzm(4) = 1
      nzero(1) = ndeg
c
      ugc = gd2/adelta
      ogc = gd1
      go to 80
c
  40  sm(1,1) = 0.
      nzm(1) = 1
      sm(1,2) = 1.
      nzm(2) = 1
      do 50 i=1,nj
        inj = nj - i
        q = float(inj)*fn
        sm(inj+1,3) = vsn/cos(q)
  50  continue
      nzm(3) = nj
      do 60 i=1,nh
        nzero(i) = 2
        q = pimn(i)
        fa = fa*q*q
        sm(i,4) = vsn/q
  60  continue
      if (nh.eq.nj) go to 70
      nzero(nj) = 1
      sm(nj,4) = flma
  70  nzm(4) = nj
c
      ugc = gd2
      ogc = gd1*adelta
  80  ack = fa
      sm(17,4) = 1.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi14
c elliptic filter
c computation of the zeros and the locations of the extrema
c-----------------------------------------------------------------------
c
      subroutine desi14
c
      double precision dpi, domi
      double precision dk, dks, dcap02, dcap04, de
      double precision dsk(16)
      double precision dcap01, dq, dn, du, dm
      double precision dellk, dsn2, del1, del2, dde, ddelta, ddelt
c
      common /const/ pi, flma, flmi, fler
      common /const2/ dpi, domi
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /resin2/ dk, dks, dcap02, dcap04
      equivalence (pren(1),dsk(1))
c
      data de /1.d00/
c
      dcap02 = de/dble(vsn)
      dcap01 = dsqrt(dcap02)
      dcap04 = dsqrt(de-dcap02*dcap02)
      dk = dellk(dcap02)
      dks = dellk(dcap04)
c
      dq = dexp(-dpi*dks/dk)
c
      nh = ndeg/2
      m = ndeg + 1
      nj = m/2
      mh = nh + 1
c
      dn = dk/dble(float(ndeg))
c
      del1 = de
      if (nh.eq.0) go to 20
      do 10 i=1,nh
        inh = m - i - i
        du = dn*dble(float(inh))
        dm = dsn2(du,dk,dq)
        del1 = del1*dm*dcap01
        dsk(i) = dm
        j = mh - i
        sm(j,1) = sngl(dm)
        nzero(i) = 2
        dde = de/(dcap02*dm)
        sm(i,4) = sngl(dde)
  10  continue
      go to 30
  20  sm(1,1) = 0.
  30  kj = nj - 1
      mj = nj + 1
      del2 = de
      if (kj.eq.0) go to 50
      do 40 i=1,kj
        ndegi = ndeg - i - i
        du = dn*dble(float(ndegi))
        dm = dsn2(du,dk,dq)
        j = mj - i
        sm(j,2) = sngl(dm)
        dde = de/(dcap02*dm)
        sm(i+1,3) = sngl(dde)
        del2 = del2*dm*dcap01
  40  continue
      go to 60
  50  sm(ndeg,2) = 1.
      sm(1,3) = vsn
c
  60  ddelt = del1*del1
      adelta = sngl(ddelt)
      ack = 1./adelta
      if (nh.eq.nj) go to 80
      ack = ack*sngl(dcap01)
      ddelta = del2*del2*dcap01
      adelta = sngl(ddelta)
      dsk(nj) = 0.d00
      nzero(nj) = 1
      sm(nj,4) = flma
c
      if (nh.eq.0) go to 90
      do 70 i=1,nh
        j = mj - i
        sm(j,1) = sm(j-1,1)
        sm(i,2) = sm(i+1,2)
  70  continue
      sm(1,1) = 0.
      go to 90
c
  80  sm(mh,3) = flma
      sm(1,2) = 0.
c
  90  nzm(1) = nj
      nzm(4) = nj
      nzm(2) = mh
      nzm(3) = mh
      sm(mh,2) = 1.
      sm(1,3) = vsn
      ugc = gd2*adelta
      ogc = gd1/adelta
      sm(17,4) = 1.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi21
c butterworth filter
c computation of the poles
c-----------------------------------------------------------------------
c
      subroutine desi21
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
c computation of constant c and reduced tolerance scheme
c
      if (acx.lt.999.) go to 20
      if ((ogc-ugc).lt.flmi) go to 10
      ac = (2.*adelp/(adelta*adels))**0.33333
      acx = alog10(ac/ugc)/alog10(ogc/ugc)
      if (acx.ge.0. .and. acx.le.1.) go to 30
  10  acx = 0.5
  20  ac = ugc*(ogc/ugc)**acx
  30  rdelp = 1. - sqrt(1./(1.+ac*ac))
      q = ac*adelta
      rdels = sqrt(1./(1.+q*q))
c
c computation of factor sfa and poles
c
      sfa = 1./ac
      q = ac**(-1./float(ndeg))
c
      do 40 i=1,nj
        spr(i) = -q*pren(i)
        spi(i) = q*pimn(i)
  40  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi22
c chebyshev filter (passband or stopband)
c computation of the poles
c-----------------------------------------------------------------------
c
      subroutine desi22
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      if (acx.lt.999.) go to 20
      if ((ogc-ugc).lt.flmi) go to 10
      if (iapro.eq.2) q = 1./adelta
      if (iapro.eq.3) q = adelta*adelta
      ac = (2.*adelp*q/adels)**0.33333
      acx = alog10(ac/ugc)/alog10(ogc/ugc)
      if (acx.ge.0. .and. acx.le.1.) go to 30
  10  acx = 0.5
  20  ac = ugc*(ogc/ugc)**acx
c
c computation of the reduced tolerance scheme
c
  30  q = ac
      if (iapro.eq.3) q = q/adelta
      q = 1. + q*q
      rdelp = 1. - sqrt(1./q)
      q = ac
      if (iapro.eq.2) q = q*adelta
      q = 1. + q*q
      rdels = sqrt(1./q)
c
c computation of the factor sfa and the poles
c
      if (iapro.eq.3) go to 40
      sfa = 2./(ac*2.**ndeg)
      q = -1./ac
      go to 50
c
  40  sfa = ack
      q = ac
  50  q = arsinh(q)/float(ndeg)
      qr = sinh(q)
      qi = cosh(q)
      if (iapro.eq.3) go to 70
      do 60 i=1,nj
        spr(i) = qr*pren(i)
        spi(i) = qi*pimn(i)
  60  continue
      return
c
  70  do 80 i=1,nh
        q = pimn(i)*qi
        qa = pren(i)*qr
        qq = q*q
        qqa = qa*qa
        sfa = sfa/(qq+qqa)
        spr(i) = -vsn/(qq/qa+qa)
        spi(i) = vsn/(q+qqa/q)
  80  continue
      if (nh.eq.nj) return
      spi(nj) = 0.
      q = vsn/qr
      sfa = sfa*q
      spr(nj) = -q
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   desi24
c elliptic filter
c computation of the reduced tolerance scheme, the factor sfa, and
c the poles
c-----------------------------------------------------------------------
c
      subroutine desi24
c
      double precision dpi, domi
      double precision dk, dks, dcap02, dcap04, de
      double precision dsk(16)
      double precision du, dr, dq, dud, duc, drc, drd, dm
      double precision dellk, dsn2
c
      common /const/ pi, flma, flmi, fler
      common /const2/ dpi, domi
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /resin2/ dk, dks, dcap02, dcap04
      equivalence (pren(1),dsk(1))
c
      data de /1.d00/
c
c if acx not defined, compute a symmetrical usage of the tolerance
c scheme
c
      if (acx.lt.999.) go to 20
      if ((ogc-ugc).lt.flmi) go to 10
      ac = (2.*adelp/(adelta*adels))**0.333333333
      acx = alog10(ac/ugc)/alog10(ogc/ugc)
      if (acx.ge.0. .and. acx.le.1.) go to 30
  10  acx = 0.5
c
  20  ac = ugc*(ogc/ugc)**acx
c
c computation of the reduced tolerance scheme
c
  30  q = ac*adelta
      du = de/dble(q)
      rdelp = 1. - sqrt(1./(1.+q*q))
      q = 1. + ac*ac/(adelta*adelta)
      rdels = sqrt(1./q)
c
c computation of the factor sfa and the poles
c
      q = ac*ack
      if (nh.eq.nj) q = sqrt(1.+q*q)
      sfa = 1./q
c
      dr = dble(adelta)
      dr = dr*dr
      dq = dble(q)
      call deli1(dq, du, dr)
      du = dq
      dq = dsqrt(de-dr*dr)
      dq = dellk(dr)
      du = dk*du/(dq*dble(float(ndeg)))
      dq = dexp(-dpi*dk/dks)
      du = -dsn2(du,dks,dq)
      dq = du*du
      dud = de - dcap04*dcap04*dq
      dud = dsqrt(dud)
      duc = dsqrt(de-dq)
      do 40 i=1,nj
        dr = dsk(i)
        drc = dr*dr
        drd = de - dcap02*dcap02*drc
        drc = dsqrt(de-drc)
        dm = de - dq*drd
        drd = dsqrt(drd)
        drd = drd*du*duc*drc/dm
        spr(i) = sngl(drd)
        dr = dr*dud/dm
        spi(i) = sngl(dr)
  40  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   tranze
c reactance transformation of the zeros and the locations of the
c extrema
c-----------------------------------------------------------------------
c
      subroutine tranze
c
      double precision dr, dqi
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
c
      dimension msm(4)
      fa = 1.
      if (ityp.eq.1) go to 190
      if (ityp.eq.3) go to 60
c
      me = nzm(4)
      do 10 i=1,me
        q = sm(i,4)
        if (q.lt.flma) fa = fa*q
  10  continue
c
      fa = fa*fa
c
c lowpass - highpass
c
      do 50 j=1,4
        me = nzm(j)
        do 40 i=1,me
          qi = sm(i,j)
          if (abs(qi).lt.flmi) go to 20
          qi = 1./qi
          go to 30
  20      qi = flma
  30      sm(i,j) = qi
  40    continue
  50  continue
      go to 90
  60  do 80 j=1,2
        me = nzm(j)
        ma = me + 1
        me = me/2
        do 70 i=1,me
          qi = sm(i,j)
          ii = ma - i
          sm(i,j) = sm(ii,j)
          sm(ii,j) = qi
  70    continue
  80  continue
c
  90  if (ityp.eq.2) go to 190
c
c lowpass - bandpass transformation
c
      qa = 2.*a
      nn = ndeg + 1
      if (ityp.eq.4) go to 110
c
      msm(1) = 1
      if (nzm(1).ne.1) msm(1) = ndeg
      msm(2) = 2
      if (nzm(2).ne.1) msm(2) = nn
      do 100 j=3,4
        msm(j) = 2*nzm(j)
 100  continue
      go to 130
c
 110  do 120 j=1,2
        msm(j) = 2*nzm(j)
 120  continue
      msm(3) = 2
      if (nzm(3).ne.1) msm(3) = nn
      msm(4) = 1
      if (nzm(4).ne.1) msm(4) = ndeg
c
 130  s = 1.
      do 180 j=1,4
        me = nzm(j)
        ma = msm(j)
        nzm(j) = ma
        if (j.eq.3) s = -1.
        do 170 i=1,me
          qr = sm(i,j)
          nu = nzero(i)
          if (abs(qr).lt.flma) go to 150
          if (j.ne.4) go to 140
          fa = fa*(vd/a)**nu
 140      qi = qr
          go to 160
c
 150      qr = qr/qa
          dr = dble(qr)
          dqi = dsqrt(dr*dr+1.d00)
          qi = sngl(dqi)
 160      sm(i,j) = qi - s*qr
          ii = ma - i + 1
          if (abs(qr).lt.flmi) nu = 2*nu
          if (j.eq.4) nzero(ii) = nu
          sm(ii,j) = qi + s*qr
 170    continue
 180  continue
c
 190  do 220 j=1,4
        me = nzm(j)
        do 210 i=1,me
          q = sm(i,j)
          if (q.lt.flma) go to 200
          if (j.ne.4 .or. ityp.ge.3) go to 210
          nu = nzero(i)
          fa = fa*vd**nu
          go to 210
 200      sm(i,j) = q*vd
 210    continue
 220  continue
      sm(17,4) = sm(17,4)*fa
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   tranpo
c reactance transformation of the poles
c-----------------------------------------------------------------------
c
      subroutine tranpo
c
      double precision dr, di, dq
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      if (ityp.eq.1) go to 90
      if (ityp.eq.3) go to 40
c
      do 30 i=1,nj
        qr = spr(i)
        qi = spi(i)
        qh = qr*qr + qi*qi
        if (abs(qi).gt.flmi) go to 10
        sfa = -sfa/qr
        go to 20
  10    sfa = sfa/qh
  20    qi = qi/qh
        if (abs(qi).lt.flmi) qi = 0.
        spi(i) = qi
        spr(i) = qr/qh
  30  continue
      if (ityp.eq.2) go to 90
c
  40  qa = 2.*a
      nn = nj
      nj = ndeg
      ndeg = 2*ndeg
c
      me = nj
      do 80 i=1,nn
        qr = spr(i)/qa
        qi = spi(i)/qa
        if (abs(qi).ge.flma) go to 70
        dr = dble(qr)
        di = dble(qi)
        dq = di*di
        di = di*dr*2.d00
        dr = dr*dr - dq - 1.d00
        call dsqrtc(dr, di, dr, di)
        qz = sngl(dr)
        qn = sngl(di)
        if (abs(qn).gt.flmi) go to 60
        jj = nj + me
        do 50 ii=me,nj
          j = jj - ii
          spr(j+1) = spr(j)
          spi(j+1) = spi(j)
  50    continue
        nj = nj + 1
        me = me + 1
  60    spr(i) = qr + qz
        spi(i) = qi + qn
        spr(me) = qr - qz
        spi(me) = qn - qi
        me = me - 1
        go to 80
c
  70    spr(i) = qr
        spi(i) = flma
        nj = nj + 1
        spr(nj) = qr
        spi(nj) = 0.
  80  continue
c
  90  do 100 i=1,nj
        spr(i) = spr(i)*vd
        spi(i) = spi(i)*vd
 100  continue
c
      sfa = sfa*sm(17,4)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   trbize
c bilinear transformation of the zeros and the locations of the extrema
c-----------------------------------------------------------------------
c
      subroutine trbize
c
      common /const/ pi, flma, flmi, fler
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
c
      fa = 1.
      do 50 j=1,4
        me = nzm(j)
        do 40 i=1,me
          qi = sm(i,j)
          zm(i,j) = 2.*atan(qi)
          if (j.ne.4) go to 40
          if (qi.ge.flma) go to 10
          if (qi.lt.flmi) go to 20
          qqi = qi*qi
          q = 1. + qqi
          zzr(i) = (1.-qqi)/q
          zzi(i) = 2.*qi/q
          nu = nzero(i)/2
          fa = fa*q**nu
          go to 40
c
  10      zzr(i) = -1.
          go to 30
c
  20      zzr(i) = 1.
  30      zzi(i) = 0.
  40    continue
  50  continue
c
      sm(17,1) = fa
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   trbipo
c bilinear transformation of the poles
c-----------------------------------------------------------------------
c
      subroutine trbipo
c
      common /const/ pi, flma, flmi, fler
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      zfa = sfa*sm(17,1)
c
      do 20 i=1,nj
        qr = spr(i)
        q = 1. - qr
        qi = spi(i)
        if (abs(qi).lt.flmi) go to 10
        qqr = qr*qr
        qqi = qi*qi
        zfa = zfa/(q-qr+qqr+qqi)
        q = 1./(q*q+qqi)
        zpr(i) = (1.-qqr-qqi)*q
        zpi(i) = 2.*qi*q
        go to 20
c
  10    zpr(i) = (1.+qr)/q
        zpi(i) = 0.
        zfa = zfa/q
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   blnumz
c build numerator blocks of second order
c-----------------------------------------------------------------------
c
      subroutine blnumz
c
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      dimension nze(16)
      common /scrat/ adum(32)
      equivalence (adum(1),nze(1))
c
      n = 0
      me = nzm(4)
      do 10 i=1,me
        nze(i) = nzero(i)
  10  continue
c
      do 70 i=1,me
        qr = zzr(i)
        nz = nze(i)
c
  20    if (nz.eq.0) go to 70
        n = n + 1
        b2(n) = 1.
        if (nz.eq.1) go to 30
        b1(n) = -2.*qr
        b0(n) = 1.
        nz = nz - 2
        if (nz.gt.0) go to 20
        go to 70
c
  30    if (i.eq.me) go to 60
        ma = i + 1
        do 40 ii=ma,me
          if (zzi(ii).eq.0.) go to 50
  40    continue
        go to 60
c
  50    qrr = zzr(ii)
        b1(n) = -qr - qrr
        b0(n) = qr*qrr
        nze(ii) = nze(ii) - 1
        go to 70
c
  60    b1(n) = -qr
        b0(n) = 0.
c
  70  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   bldenz
c build denominator blocks of second order  --  z-domain
c-----------------------------------------------------------------------
c
      subroutine bldenz
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      nb = (ndeg+1)/2
      n = 0
      fact = zfa
c
      do 40 i=1,nb
        n = n + 1
        qr = zpr(n)
        qi = zpi(n)
        if (abs(qi).lt.flmi) go to 10
        c1(i) = -2.*qr
        c0(i) = qr*qr + qi*qi
        go to 40
c
  10    if (n.ge.nj) go to 20
        if (abs(zpi(n+1)).lt.flmi) go to 30
  20    c1(i) = -qr
        c0(i) = 0.
        go to 40
c
  30    n = n + 1
        qi = zpr(n)
        c1(i) = -qr - qi
        c0(i) = qr*qi
  40  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   romeg
c realized frequencies omega
c-----------------------------------------------------------------------
c
      subroutine romeg
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
c
      n2 = nzm(2)
      n3 = nzm(3)
      go to (10, 20, 30, 40), ityp
  10  rom(1) = zm(n2,2)
      rom(2) = zm(1,3)
      go to 50
  20  rom(1) = zm(1,3)
      rom(2) = zm(n2,2)
      go to 50
  30  rom(1) = zm(n3,3)
      rom(2) = zm(1,2)
      rom(3) = zm(n2,2)
      rom(4) = zm(1,3)
      go to 50
  40  n2 = n2/2
      rom(1) = zm(n2,2)
      rom(4) = zm(n2+1,2)
      rom(3) = zm(1,3)
      rom(2) = zm(n3,3)
  50  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   transn
c computation of the parameters of the normalized lowpass
c-----------------------------------------------------------------------
c
      subroutine transn
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      tan2(aa) = sin(aa/2.)/cos(aa/2.)
c
      v1 = tan2(om(1))
      v2 = tan2(om(2))
      if (ityp.le.2) go to 210
      v3 = tan2(om(3))
      v4 = tan2(om(4))
      if (ityp.eq.3) go to 10
      q = v1
      v1 = -v4
      v4 = -q
      q = v2
      v2 = -v3
      v3 = -q
      if (lsym.ne.0) lsym = 5 - lsym
      if (lvsn.eq.0) go to 10
      j = 5 - lvsn
      lvsn = lsym
      lsym = j
c
  10  j = lsym + 1
      jj = lvsn/2 + 1
      go to (20, 80, 120, 160, 180), j
  20  j = norma + 1
      go to (30, 30, 40, 70), j
  30  vdq1 = v2*v3
      vsn1 = vdq1/v1 - v1
      q = v4 - vdq1/v4
      if (q.lt.vsn1) vsn1 = q
      a1 = 1./(v3-v2)
      vsn1 = vsn1*a1
      go to (40, 50, 40), j
  40  vdq = v1*v4
      a = v2/(vdq-v2*v2)
      q = v3/(v3*v3-vdq)
      if (q.lt.a) a = q
      vsn = a*(v4-v1)
      if (norma.eq.2) go to 200
      if (vsn.ge.vsn1) go to 200
  50  vdq = vdq1
  60  vsn = vsn1
      a = a1
      go to 200
c
  70  vdq = sqrt(v1*v2*v3*v4)
      a1 = v3/(v3*v3-vdq)
      vsn1 = (v4-vdq/v4)*a1
      a = v2/(vdq-v2*v2)
      vsn = (vdq/v1-v1)*a
      if (vsn.ge.vsn1) go to 200
      go to 60
c
  80  go to (90, 100, 110), jj
  90  vdq = v2*v3
      vsn = v4 - vdq/v4
      go to 190
 100  v3 = v4*(v4+vsn*v2)/(v2+vsn*v4)
 110  vdq = v2*v3
      a = 1./(v3-v2)
      go to 200
 120  go to (130, 150, 140), jj
 130  vdq = v1*v4
      a = v3/(v3*v3-vdq)
      go to 170
 140  v4 = v3*(v1+vsn*v3)/(v3+vsn*v1)
 150  vdq = v1*v4
      a = vsn/(v4-v1)
      go to 200
 160  vdq = v1*v4
      a = v2/(vdq-v2*v2)
 170  vsn = (v4-v1)*a
      go to 200
 180  vdq = v2*v3
      vsn = vdq/v1 - v1
 190  a = 1./(v3-v2)
      vsn = vsn*a
c
 200  vd = sqrt(vdq)
      a = a*vd
      if (ityp.le.3) go to 270
      a = a/vsn
      go to 270
c
 210  j = lvsn*2 + ityp
      go to (220, 220, 230, 240, 250, 260), j
 220  vsn = v2/v1
      go to (250, 240), j
 230  vd = v2/vsn
      go to 270
 240  vd = v2
      go to 270
 250  vd = v1
      go to 270
 260  vd = v1*vsn
c
 270  return
      end
c
c ======================================================================
c
c doredi - subroutines: part ii
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   grid01
c build a start grid for the search of the global extremes of the
c transfer function with rounded coefficients
c-----------------------------------------------------------------------
c
      subroutine grid01
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /cgrid/ gr(64), ngr(12)
c
      m = ndeg
      if (ndeg.gt.22) m = 22
      if (ityp.ge.3) m = m/2
      m1 = m/2
      fm = pi/float(2*m)
      m11 = 2*m1 + 1
      fm1 = pi/float(m11)
      m = m + 1
      ph2 = 1.5*pi
c
      ngr(8) = 1
c
c bandpass
c
      n = 0
      go to (70, 10, 20, 40), ityp
c
c highpass
c
  10  ia = 1
      ib = nzm(2)
      go to 30
c
c bandpass
c
  20  ia = nzm(3)
      ib = 1
  30  n = n + 1
      gr(n) = 0.
      go to 50
c
c bandstop
c
  40  ia = 1
      ib = nzm(2)/2 + 1
  50  j = 1
      ph1 = 0.
      ja = 3
      jb = 2
      go to 350
  60  ngr(1) = n + 1
  70  k = 2
      l = 1
      mak = 1
      mal = 1
      mek = nzm(k)
      mel = nzm(l)
      j = 1
      go to (80, 90, 100, 110), ityp
c
c lowpass
c
  80  id = 1
      ngr(1) = 1
      ph = 0.
      if (mek.gt.mel) go to 370
      iq = mek
      mek = mel
      mel = iq
      k = 1
      l = 2
      go to 370
c
c highpass
c
  90  id = -1
      go to 130
c
c bandpass
c
 100  mek = mek/2
      mel = mek
      go to 120
c
c bandstop
c
 110  mak = mek/2 + 1
      mal = mel/2 + 1
 120  id = 1
 130  ph = ph2
      go to 370
c
 140  ngr(2) = n
      go to (150, 160, 160, 160), ityp
c
c lowpass
c
 150  ia = nzm(2)
      ib = 1
      ja = 2
      jb = 3
      ph1 = ph2
      j = 2
      go to 350
 160  ngr(3) = n
      if (ityp.le.2) go to 230
      k = 2
      l = 1
      mek = nzm(k)
      mel = nzm(l)
      if (ityp.eq.3) go to 180
      if (mek.gt.mel) go to 170
      k = 1
      l = 2
 170  mek = mek/2
      mel = mel/2
      mak = 1
      mal = 1
      go to 190
 180  mak = mek/2 + 1
      mal = mak
 190  id = 1
      ph = 0.
      j = 2
      go to 370
c
 200  ngr(4) = n
      if (ityp.eq.3) go to 210
c
c bandstop
c
      ia = nzm(2)/2
      ib = nzm(3)
      go to 220
c
c bandpass
c
 210  ia = nzm(2)
      ib = 1
 220  ja = 2
      jb = 3
      ph1 = ph2
      j = 3
c
      go to 350
 230  if (abs(gr(n)-pi).lt.flmi) go to 240
      n = n + 1
      gr(n) = pi
 240  ngr(9) = n
      ngr(5) = n
c
c bandstop
c
      k = 3
      l = 4
      mek = nzm(k)
      mel = nzm(l)
      mak = 1
      mal = 1
      j = 3
      id = 1
      go to (280, 250, 270, 250), ityp
c
c highpass
c
 250  if (mek.gt.mel) go to 260
      iq = mek
      mek = mel
      mel = iq
      k = 4
      l = 3
 260  ph = 0.
      id = -1
      if (ityp.ne.4) go to 330
c
c bandstop
c
      mak = mek/2 + 1
      mal = mel/2 + 1
      go to 280
c
c bandpass
c
 270  mek = mek/2
      mel = mel/2
 280  ph = ph2
      go to 380
c
 290  ngr(6) = n
      j = 4
      go to (500, 500, 300, 320), ityp
c
c bandpass
c
 300  if (mek.gt.mel) go to 310
      iq = mek
      mek = mel
      mel = iq
      k = 4
      l = 3
 310  mak = mek + 1
      mal = mel + 1
      mek = nzm(k)
      mel = nzm(l)
      go to 330
c
c bandstop
c
 320  mek = mek/2
      mel = (mel+1)/2
      k = 4
      l = 3
      mak = 1
      mal = 1
 330  ph = 0.
      go to 380
c
 340  ngr(7) = n
      go to 500
c
 350  qa = zm(ia,ja)
      qd = zm(ib,jb) - qa
      if (ph1.ne.0.) qa = qa + qd
      do 360 i=1,m1
        n = n + 1
        q = float(i)*fm1 + ph1
        gr(n) = qa + sin(q)*qd
 360  continue
      go to (60, 160, 230), j
c
 370  go to (460, 390, 460, 390), iapro
 380  go to (460, 460, 390, 390), iapro
c
c multiple extrema
c
 390  if (id.lt.0) go to 400
      ik = mak
      il = mal
      go to 410
c
 400  ik = mek
      il = mel
 410  do 450 i=mak,mek
        n = n + 1
        gr(n) = zm(ik,k)
        if (il.gt.mel .or. il.lt.mal) go to 440
        if (ndeg.le.22) go to 420
        if (il.ne.mel .and. il.ne.mal) go to 430
 420    n = n + 1
        gr(n) = zm(il,l)
 430    il = il + id
 440    ik = ik + id
 450  continue
      go to 490
c
c single extrema
c
 460  qa = zm(mek,k)
      qd = zm(mel,l)
      if (qd.gt.qa) go to 470
      q = qa
      qa = qd
      qd = q
 470  qd = qd - qa
      if (ph.ne.0.) qa = qa + qd
      do 480 i=1,m
        n = n + 1
        ii = i - 1
        q = float(ii)*fm + ph
        gr(n) = qa + sin(q)*qd
 480  continue
 490  go to (140, 200, 290, 340), j
c
 500  ngr(10) = ngr(3) + 1
      ngr(11) = ngr(5) + 1
      ngr(12) = ngr(6) + 1
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   grid03
c start values for the calculation of a grid
c-----------------------------------------------------------------------
c
      subroutine grid03
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
c
      if (ityp.le.0 .or. ityp.gt.4) go to 70
      if (ndeg.le.0) go to 70
      iapro = 1
      do 10 i=1,4
        nzm(i) = (ityp+1)/2
  10  continue
      me = 2
      if (ityp.ge.3) me = 4
      do 20 i=1,me
        if (om(i).le.0.) go to 80
  20  continue
c
      go to (30, 40, 50, 60), ityp
  30  zm(1,1) = 0.
      zm(1,2) = om(1)
      zm(1,3) = om(2)
      zm(1,4) = pi
      go to 100
  40  zm(1,1) = pi
      zm(1,2) = om(2)
      zm(1,3) = om(1)
      zm(1,4) = 0.
      go to 100
  50  nzm(1) = 1
      zm(1,1) = (om(2)+om(3))/2.
      zm(1,2) = om(2)
      zm(2,2) = om(3)
      zm(1,3) = om(4)
      zm(2,3) = om(1)
      zm(1,4) = pi
      zm(2,4) = 0.
      go to 100
  60  zm(1,1) = 0.
      zm(2,1) = pi
      zm(1,2) = om(1)
      zm(2,2) = om(4)
      zm(1,3) = om(3)
      zm(2,3) = om(2)
      nzm(4) = 1
      zm(1,4) = (om(2)+om(3))/2.
      go to 100
c
  70  ie = 20
      go to 90
  80  ie = 23
  90  call error(ie)
 100  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   grid04
c change grid for unsymmetrical tolerance scheme
c-----------------------------------------------------------------------
c
      subroutine grid04
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /cgrid/ gr(64), ngr(12)
c
      if (ityp.le.2) go to 130
      do 10 i=1,4
        if (om(i).eq.0.) go to 130
  10  continue
c
      i = 1
      ma = ngr(1)
      me = ngr(2)
      if (ityp.eq.3) omm = om(2)
      if (ityp.eq.4) omm = om(4)
      n = 1
      go to 50
c
  20  ma = ngr(10)
      me = ngr(4)
      if (ityp.eq.3) omm = om(3)
      if (ityp.eq.4) omm = om(1)
      n = 4
      go to 90
c
  30  i = 2
      ma = ngr(11)
      me = ngr(6)
      if (ityp.eq.3) omm = om(4)
      if (ityp.eq.4) omm = om(2)
      n = 11
      go to 50
c
  40  ma = ngr(12)
      me = ngr(7)
      if (ityp.eq.3) omm = om(1)
      if (ityp.eq.4) omm = om(3)
      n = 7
      go to 90
c
  50  do 60 ii=ma,me
        j = me + ma - ii
        if ((gr(j)-omm).le.fler) go to 70
  60  continue
      go to 80
  70  gr(j) = omm
      ngr(n) = j
  80  if (i.eq.1) go to 20
      go to 40
c
  90  do 100 ii=ma,me
        if ((gr(ii)-omm).ge.(-fler)) go to 110
 100  continue
      go to 120
 110  gr(ii) = omm
      ngr(n) = ii
 120  if (i.eq.1) go to 30
c
 130  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   coefw
c search of the minimum coefficient wordlength
c computation of the optimization criterion
c-----------------------------------------------------------------------
c
      subroutine coefw
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /const/ pi, flma, flmi, fler
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /cepsil/ eps(2), pmax
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      complex zp, zps
      common /cpol/ zp(16,2), zps(16,2)
c
      iwlrr = iwlr
      iwlr = 100
      iwlg = iwlma
      iwld = 0
      iwlm = iwl
      ii1 = 1
      ii2 = 0
      ii3 = 0
      call copy01
      if (iprun.gt.0) go to 20
      if (lseq.ne.(-1)) go to 10
      call allo02
      call copy01
      if (nout.ge.2) call out011
  10  call allo01
      call copy01
  20  if (nout.eq.4) call out043
      call reco
  30  call copy02
      if (iprun.gt.0) go to 70
      call round(4, 5)
      if (iscal.ne.3) go to 40
      call polloc
      call copy03
  40  amax = 1.
      fact = 1.
      do 60 j=1,nb
        ib = j
  50    call scal01
        call scal02
        if (jstrud.eq.1) go to 60
        if (ib.ne.nb) go to 60
        ib = ib + 1
        go to 50
  60  continue
      call reco
      call round(1, 3)
      go to 80
  70  call round(1, 5)
  80  call stable
      if (nout.ge.5) call out046
      if (istab.ne.(-1)) go to 250
      call epsilo
      ideps = 0
      do 90 k=1,2
        if (eps(k).gt.1.) ideps = ideps + 1
  90  continue
      if (nout.ge.5) call out043
      if (nout.ge.4) call out044
      adeps = eps(1) - eps(2)
      if (loptw.ne.(-1)) go to 260
      if (iwl.ne.iwll) go to 100
      adepsl = adeps
      idepsl = ideps
 100  if (ideps.eq.0) go to 110
      if (iwl.le.iwld .or. iwl.gt.iwlg) go to 120
      iwld = iwl
      adepsd = adeps
      idepsd = ideps
      go to 120
 110  if (iwl.ge.iwlg) go to 120
      iwlg = iwl
      adepsg = adeps
      if (iwld.le.iwlg) go to 120
      iwld = 0
      ii3 = 0
 120  go to (130, 140, 180), ii1
 130  ii1 = 2
      if (ideps.eq.2) ii1 = 3
      go to 120
 140  if (ideps.ne.0) go to 170
 150  ii2 = ii2 + 1
 160  iwl = iwl - 1
      go to 220
 170  ii3 = ii3 + 1
      if (ii3.lt.2) go to 160
      if (ii2.ge.2) go to 270
      iwl = iwlm + 1
      ii1 = 3
      go to 220
 180  if (ideps.eq.0) go to 210
 190  ii3 = ii3 + 1
 200  iwl = iwl + 1
      go to 220
 210  ii2 = ii2 + 1
      if (ii2.lt.2) go to 200
      if (ii3.ge.2) go to 270
      iwl = iwlm - 1
      ii1 = 2
 220  if (iwl.ge.iwlmi .and. iwl.le.iwlma) go to 30
 230  if (ii1.eq.3) go to 240
      if (ideps.eq.0) go to 270
      ii1 = 3
      ii2 = 2
      go to 190
 240  ii1 = 2
      if (ideps.ne.0) go to 270
      ii3 = 2
      go to 150
 250  if (loptw.ne.(-1)) go to 270
      if (ii1.ne.1) go to 230
      iwl = iwl + 1
      if (iwl.le.iwlma) go to 30
 260  adepsd = adeps
      iwlg = iwl
      iwld = iwl
 270  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   reco
c transform the coefficients for the chosen realization
c-----------------------------------------------------------------------
c
      subroutine reco
c
      common /const/ pi, flma, flmi, fler
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
c
      dimension aco(16,5)
      equivalence (aco(1,1),b2(1))
      equivalence (irco(1),irb2), (irco(2),irb1), (irco(3),irb0)
      equivalence (irco(4),irc1), (irco(5),irc0)
c
      alog2 = alog(2.)
c
c representation of the coefficients with differences
c
      if (jdco.eq.0) go to 70
      do 60 j=1,5
        acom = 0.
        do 10 i=1,nb
          acom = amax1(abs(aco(i,j)),acom)
  10    continue
        if (acom.ge.flmi) go to 20
        id = -100
        go to 30
  20    id = alog(acom)/alog2
        q = 2.**id
        if (q.ge.acom) go to 30
        id = id + 1
        q = q*2.
  30    jj = jjdco(j)
        if (jj.eq.0) go to 60
        bcom = 0.5*q
        do 50 i=1,nb
          ac = aco(i,j)
          aca = abs(ac)
          if (aca.ge.bcom) go to 40
          if (jj.ne.1) go to 50
  40      idco(i,j) = id
  50    continue
  60  continue
c
c range of coefficient numbers
c
  70  if (jrco.eq.0) go to 180
      do 120 j=1,5
        acom = 0.
        bcom = 0.
        do 80 i=1,nb
          acs = acoefs(aco(i,j),0,idco(i,j),0)
          acom = amin1(acom,acs)
          bcom = amax1(bcom,acs)
  80    continue
        acom = amax1(abs(acom),bcom)
        if (acom.ge.flmi) go to 90
        iq = -100
        go to 110
  90    iq = alog(acom)/alog2
        q = 2.**iq
        if (q.lt.acom) go to 100
        if (jmaxv.le.1) go to 110
        if (jmaxv.eq.2 .and. q.gt.bcom) go to 110
        if (jmaxv.eq.3 .and. q.gt.acom) go to 110
 100    iq = iq + 1
 110    if (jrco.gt.0) iq = max0(iq,0)
        irco(j) = iq
 120  continue
      jj = iabs(jrco)
      go to (180, 130, 130, 150, 160), jj
 130  iq = max0(irb2,irb1,irb0)
      do 140 j=1,3
        irco(j) = iq
 140  continue
      if (jj.eq.2) go to 180
      iq = max0(irc1,irc0)
      irc1 = iq
      irc0 = iq
      go to 180
 150  iq = max0(irb1,irc1)
      irb1 = iq
      irc1 = iq
      go to 180
 160  iq = max0(irb2,irb1,irb0,irc1,irc0)
      do 170 j=1,5
        irco(j) = iq
 170  continue
c
c compute "pseudo" floating-point exponents
c
 180  if (jeco.eq.0) go to 230
      iecom = 0
      do 220 j=1,5
        do 210 i=1,nb
          qa = acoefs(aco(i,j),0,idco(i,j),irco(j))
          qa = abs(qa)
          if (qa.ge.flmi) go to 190
          iq = jeco
          go to 200
 190      iq = -alog(qa)/alog2
          if (iq.gt.jeco) iq = jeco
 200      ieco(i,j) = iq
          iecom = max0(iecom,iq)
 210    continue
 220  continue
 230  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   round
c rounding of the changed coefficients
c-----------------------------------------------------------------------
c
      subroutine round(ira, irb)
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
      dimension aco(16,5)
      equivalence (aco(1,1),b2(1))
c
      alsb = 2.**(1-iwl)
      elsb = 1. - alsb
      do 120 i=1,nb
        do 110 j=ira,irb
          ac = aco(i,j)
          if (j.ne.2 .and. j.ne.3) go to 10
          if (aco(i,1).eq.ac) go to 110
  10      acs = acoefs(ac,ieco(i,j),idco(i,j),irco(j))
          acsa = abs(acs)
          if (acsa.lt.alsb .and. j.eq.1) go to 110
          if (acsa.gt.elsb) go to 30
          r = 0.5
          if (j.ne.1 .or. jtrb2.le.0) go to 20
          r = 0.
          if (idco(i,j).gt.(-100)) r = 1.
  20      acsa = aint(acsa/alsb+r)
          acsa = acsa*alsb
          go to 50
  30      if (jmaxv.ge.1) go to 40
          if (jmaxv.eq.(-2) .and. ac.lt.0.) go to 40
          acsa = elsb
          go to 50
  40      acsa = 1.
  50      bc = sign(acsa,acs)
          bc = acoef(bc,ieco(i,j),idco(i,j),irco(j))
          aco(i,j) = bc
          if (j.ne.1) go to 110
          f = bc/ac
          jj = iabs(jtrb2)
          go to (100, 80, 60), jj
  60      do 70 k=2,3
            aco(i,k) = aco(i,k)*f
  70      continue
  80      ii = i + 1
          if (ii.gt.nb) go to 100
          do 90 k=1,3
            aco(ii,k) = aco(ii,k)/f
  90      continue
          go to 110
 100      fact = fact/f
 110    continue
 120  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   stable
c check stability of the rounded system
c-----------------------------------------------------------------------
c
      subroutine stable
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
c
      do 120 i=1,nb
        it = 0
        cc0 = c0(i)
        cc1 = c1(i)
        if (cc0.ge.1.) go to 20
        ac1 = abs(cc1)
  10    if (ac1.ge.1.+cc0) go to 30
        if (it.eq.0) go to 120
        go to 110
  20    it = it + 1
        go to 40
  30    it = it + 2
  40    if (lstab.ne.(-1)) go to 130
        alsb = 2.**(1-iwl)
        q0 = acoef(alsb,ieco(i,5),-100,irco(5))
        if (it.ge.2) go to 50
        cc0 = cc0 - q0
        go to 10
  50    if (it.ge.3) go to 80
        ac0 = cc0
  60    ac0 = ac0 + q0
        if (ac0.ge.1.) go to 70
        if (ac1.ge.1.+ac0) go to 60
        q3 = ac1 - abs(sc1(i))
        q2 = ac0 - sc0(i)
        a = q3*q3 + q2*q2
        a = sqrt(a)
        go to 80
  70    it = 3
  80    q1 = acoef(alsb,ieco(i,4),-100,irco(4))
        bc1 = ac1
  90    bc1 = bc1 - q1
        if (bc1.ge.1.+ac0) go to 90
        if (it.eq.3) go to 100
        q3 = bc1 - abs(sc1(i))
        q2 = cc0 - sc0(i)
        b = q3*q3 + q2*q2
        b = sqrt(b)
        if (a.ge.b) go to 100
        bc1 = ac1
        cc0 = ac0
 100    c1(i) = sign(bc1,cc1)
 110    c0(i) = cc0
 120  continue
      istab = -1
      return
 130  istab = 0
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   epsilo
c computation of the global extrema of the transfer function
c with rounded coefficients
c computation of the error values epsilon
c-----------------------------------------------------------------------
c
      subroutine epsilo
c
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /cgrid/ gr(64), ngr(12)
      common /cepsil/ eps(2), pmax
c
c maximum in the passband(s)
c
      me = 3
      if (ityp.eq.3) me = 5
      call smax(pmax, 8, me, 1)
      if (ityp.ne.4) go to 10
      call smax(qmax, 10, 5, 1)
      pmax = amax1(pmax,qmax)
c
c minimum in the passband(s)
c
  10  me = 2
      if (ityp.eq.3) me = 4
      call smax(pmin, 1, me, -1)
      if (ityp.ne.4) go to 20
      call smax(qmin, 10, 4, -1)
      pmin = amin1(pmin,qmin)
c
c maximum in the stopband(s)
c
  20  me = 6
      if (ityp.eq.4) me = 7
      call smax(stmax, 11, me, 1)
      if (ityp.ne.3) go to 30
      call smax(qmax, 12, 7, 1)
      stmax = amax1(stmax,qmax)
c
c computation of epsilon
c
  30  eps(1) = (1.-pmin/pmax)/adelp
      eps(2) = stmax/pmax/adels
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   optpar
c optimization of the coefficient wordlength by variation of the
c design parameter acx
c-----------------------------------------------------------------------
c
      subroutine optpar
c
      common /const/ pi, flma, flmi, fler
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /coptcp/ is1, is2, iabo, iwlgs, iwlgn, iwlgp, adepss,
     *    adepsn, adepsp, acxs, acxn, acxp
c
      if (loptw.ne.(-1)) go to 40
      if (iwld.gt.iwll .and. idepsl.lt.2) go to 20
      if (idepsd.ne.2) go to 10
      adepsd = adepsg
      iwld = iwlg
  10  iwll = iwld
      go to 30
  20  adepsd = adepsl
      iwld = iwll
  30  iwl = iwld
  40  iabo = iabo + 1
      if (adepsd.lt.0.) go to 80
      if (is1.ne.(-1)) go to 50
      if (is2.ne.(-1)) go to 70
      go to 60
  50  if (is2.ne.(-1)) go to 60
      is1 = -1
  60  is2 = -((is2+2)/2)
      acxa = (acx+acxn)/2.
      go to 120
  70  acxa = (acx+acxmi)/2.
      go to 120
c
  80  if (is1.eq.(-1)) go to 90
      if (is2.ne.(-1)) go to 110
      go to 100
  90  if (is2.ne.(-1)) go to 100
      is1 = 0
 100  is2 = -((is2+2)/2)
      acxa = (acx+acxp)/2.
      go to 120
 110  acxa = (acx+acxma)/2.
c
 120  if (iwlg.lt.iwlgs) go to 130
      if (adepss-abs(adepsd).le.flmi .or. iwlg.gt.iwlgs) go to 140
 130  iwlgs = iwlg
      adepss = abs(adepsd)
      acxs = acx
 140  if (adepsd.lt.0.) go to 160
      if (iwlg.lt.iwlgp) go to 150
      if (adepsp-adepsd.le.flmi .or. iwlg.gt.iwlgp) go to 190
 150  iwlgp = iwlg
      adepsp = adepsd
      acxp = acx
      go to 180
 160  if (iwlg.lt.iwlgn) go to 170
      if (adepsn-adepsd.ge.flmi .or. iwlg.gt.iwlgn) go to 190
 170  iwlgn = iwlg
      adepsn = adepsd
      acxn = acx
 180  iabo = 0
 190  acx = acxa
      return
      end
c
c ======================================================================
c
c doredi - subroutines: part iii
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   grid02
c build a start grid out of the pole locations for the search of the
c global extremes of the transfer function
c-----------------------------------------------------------------------
c
      subroutine grid02
c
      common /const/ pi, flma, flmi, fler
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /cgrid/ gr(64), ngr(12)
c
      ngr(1) = 0
      j = 1
      gr(1) = 0.
      do 10 i=1,nb
        q = -c1(i)/2.
        qn = c0(i)
        if (abs(qn).lt.flmi) go to 10
        qn = qn - q*q
        if (qn.le.0.) go to 10
        j = j + 1
        gr(j) = atan2(sqrt(qn),q)
  10  continue
      j = j + 1
      gr(j) = pi
      ngr(8) = 1
      ngr(9) = j
c
c sorting of the locations
c
      j = j - 1
  20  jj = 0
      do 30 i=1,j
        q1 = gr(i)
        q2 = gr(i+1)
        if (q1.lt.q2) go to 30
        jj = 1
        gr(i) = q2
        gr(i+1) = q1
  30  continue
      if (jj.ne.0) go to 20
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   ananoi
c noise analysis of a given cascade
c-----------------------------------------------------------------------
c
      subroutine ananoi
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /coptst/ lopts, istor
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /cpow/ pnu, pnc, and, itcorp
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
      common /cnoise/ ri, rin, re, ren, fac
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
c
      iq = iwlr
      if (iq-1.gt.iwlma) iq = iwlma + 1
      iq = iq - 2
      alsbi = 2.**iq
      ib = nb
      if (lopts.ne.0) go to 20
      do 10 i=1,nb
        jseqn(i) = i
        jseqd(i) = i
  10  continue
      go to 40
  20  do 30 i=1,nb
        jseqn(i) = iseq(i,1)
        jseqd(i) = iseq(i,2)
  30  continue
  40  sand = 0.
      spnu = 0.
      spnc = 0.
      call allond
      call smax(q, 8, 9, 1)
      fac1 = fact/q
      if (iscal.ne.0 .or. jstrud.eq.1) fact = 1.
      amax = 1.
      itcorp = -1
c
      do 80 i=1,nb
        ib = i
        if (istru.ge.30) go to 60
  50    if (iscal.eq.0) sca = 1.
        if (iscal.ne.0) call scal01
        call alns01
        call alns02
        go to 70
  60    continue
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert the calls to your own structure implementations
c see subroutine optlst
c
        call error(8)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
  70    q = fac1/fact
        call power
        and = and*q
        pnc = q
        q = q*q
        pnu = pnu*q
        call pcorp
        pnc = pnc*q
        sand = sand + and
        spnu = spnu + pnu
        spnc = spnc + pnc
        if (nout.ge.3) call out026
        if (iscal.ne.0) call scal02
        if (jstrud.eq.1 .or. ib.ne.1) fac1 = fac1/sca
        if (jstrud.eq.1) go to 80
        if (ib.ne.nb) go to 80
        ib = ib + 1
        go to 50
  80  continue
      call tcorp
      rin = spnu + sand*sand + pnc
      fac = fact/fac1
      q = fac*fac
      ri = rin*q
      if (nout.lt.3) go to 90
      ib = 0
      and = sand
      pnu = spnu
      call out026
  90  call spow(re)
      ren = re/q
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   optlst
c optimization of the pairing and ordering by the procedure with
c limited storage
c dynamic programming for systems of an order less than or equal to ten
c direct procedure for the parameter istor equal to one
c-----------------------------------------------------------------------
c
      subroutine optlst
c
      common /const/ pi, flma, flmi, fler
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /coptst/ lopts, istor
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /copst1/ lseqn(16,100,2), lseqd(16,100,2)
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
      common /cpow/ pnu, pnc, and, itcorp
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
      common /cnoise/ ri, rin, re, ren, fac
c
      dimension iseqn(16), iseqd(16)
      equivalence (iseqn(1),iseq(1,1)), (iseqd(1),iseq(1,2))
c
      itcorp = 0
      alsbi = 2.**(iwlma-1)
      ii = 1
      pn(1,2) = 0.
      tf(1,2) = 1.
      tfa(1,2) = 1.
      call smax(q, 8, 9, 1)
      fac1 = fact/q
      js = 1
      is = 2
      in = 1
      pntm = flma
      ma = nb
      if (lopts.ne.(-1)) ma = 1
c
      do 220 ik=1,nb
        iik = ik
        mk = ik - 1
        iq = is
        is = js
        js = iq
        jn = in
        in = 0
c
c extension of the assigned ordering
c
        do 210 jk=1,jn
          if (ik.eq.1) go to 10
          call code4(jseqd, lseqd(1,jk,js), mk)
          if (lopts.eq.(-1)) call code4(jseqn, lseqn(1,jk,js), mk)
  10      do 200 i=1,nb
            if (ik.eq.1) go to 30
            do 20 ii=1,mk
              if (jseqd(ii).eq.i) go to 200
  20        continue
  30        jseqd(ik) = i
            do 190 j=1,ma
              if (lopts.ne.(-1)) go to 60
              if (ik.eq.1) go to 50
              do 40 ii=1,mk
                if (jseqn(ii).eq.j) go to 190
  40          continue
  50          jseqn(ik) = j
c
  60          fact = tf(jk,js)
              amax = tfa(jk,js)
              pnt = pn(jk,js)
              ib = ik
              call allond
  70          if (istru.ge.30) go to 80
              call scal01
              call alns01
              call alns02
              go to 90
  80          continue
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert the calls to your own structure implementations
c scaling of the ib-th block
c allocations of the noise sources in the ib-th block
c allocation of the input transfer functions
c  fact : product of the ib-1 scaling factors in front
c  amax : scaling of the (ib-1)-th block
c  jstru  = 1 : second coefficient optimization
c  jstru  = 2 : no second optimization
c  jstrus = 1 : no separate scaling factor
c  jstrus = 2 : separate scaling factor
c  jstrud = 1 : numerator first
c  jstrud = 2 : denominator first
c  bn2(i),bn1(i),bn0(i) : noise transfer function in the ib-th block
c  bf2(i),bf1(i),bf0(i) : transfer functions in the ib-th block
c                         from the input to the nonlinearities
c  ibb(i) .ne. ib : block ib only numerator
c  phi(i) : variance of the input transfer functions
c
c remove the following statement
c
              call error(8)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
  90          q = fac1/fact
              call power
              call pcorp
              pnt = (pnu+pnc+and*and)*q*q + pnt
              if (jstrud.eq.1) go to 100
              if (ib.ne.nb) go to 100
              ib = ib + 1
              go to 70
 100          if (ik.eq.nb) go to 170
c
c store intermediate result
c check if combination is in storage
c
              if (ik.eq.1) go to 130
              if (in.eq.0) go to 150
              do 120 il=1,in
                call code5(iseqd, lseqd(1,il,is), iik, jseqd, ii)
                if (ii.eq.2) go to 120
                if (lopts.ne.(-1)) go to 110
                call code5(iseqn, lseqn(1,il,is), iik, jseqn, ii)
                if (ii.eq.2) go to 120
 110            continue
                if (pn(il,is).le.pnt) go to 190
                call code3(jseqd, lseqd(1,il,is), iik)
                if (lopts.eq.(-1)) call code3(jseqn, lseqn(1,il,is),
     *              iik)
                pn(il,is) = pnt
                tf(il,is) = fact
                tfa(il,is) = amax
                go to 190
 120          continue
 130          if (in.lt.istor) go to 150
c
c search in the storage for the allocation with greatest noise power
c
              pnm = pnt
              iq = 0
              do 140 ii=1,istor
                if (pn(ii,is).lt.pnm) go to 140
                iq = ii
                pnm = pn(ii,is)
 140          continue
              if (iq.eq.0) go to 190
              go to 160
 150          in = in + 1
              iq = in
 160          pn(iq,is) = pnt
              tf(iq,is) = fact
              tfa(iq,is) = amax
              call code3(jseqd, lseqd(1,iq,is), iik)
              if (lopts.eq.(-1)) call code3(jseqn, lseqn(1,iq,is), iik)
              go to 190
c
c check result
c
 170          if (pnt.ge.pntm) go to 190
              pntm = pnt
              fac = fact
              do 180 ii=1,nb
                iseqd(ii) = jseqd(ii)
                iseqn(ii) = jseqn(ii)
 180          continue
 190        continue
 200      continue
          if (ik.eq.1) go to 220
 210    continue
 220  continue
      fac = fac/fac1
      rin = pntm
      ri = rin*fac*fac
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   allond
c allocation of the numerator and denominator blocks
c-----------------------------------------------------------------------
c
      subroutine allond
c
      complex zp, zps
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /cpol/ zp(16,2), zps(16,2)
      common /coptst/ lopts, istor
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      do 40 i=1,ib
        j = jseqd(i)
        c1(i) = sc1(j)
        c0(i) = sc0(j)
        zp(i,1) = zps(j,1)
        zp(i,2) = zps(j,2)
        if (lopts.ne.1) go to 20
        if (jstrud.eq.1) go to 30
        if (i.ne.ib) go to 10
        j = jseqd(1)
        go to 30
  10    j = jseqd(i+1)
        go to 30
  20    j = jseqn(i)
  30    b2(i) = sb2(j)
        b1(i) = sb1(j)
        b0(i) = sb0(j)
        jseqn(i) = j
  40  continue
      if (ib.ge.nb) return
      ii = ib
      jj = ib
      do 80 i=1,nb
        do 50 j=1,ib
          if (jseqd(j).eq.i) go to 60
  50    continue
        ii = ii + 1
        c1(ii) = sc1(i)
        c0(ii) = sc0(i)
        zp(ii,1) = zps(i,1)
        zp(ii,2) = zps(i,2)
  60    do 70 j=1,ib
          if (jseqn(j).eq.i) go to 80
  70    continue
        jj = jj + 1
        b2(jj) = sb2(i)
        b1(jj) = sb1(i)
        b0(jj) = sb0(i)
  80  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   scal01
c scaling of the ib-th block
c-----------------------------------------------------------------------
c
      subroutine scal01
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      nnb = nb
      bmax = 0.
      j = 1
      if (ib.gt.nb) go to 30
      nb = ib
      if (jstrud.eq.1) go to 30
      j = 2
      bb1 = b1(ib)
      bb0 = b0(ib)
      b1(ib) = 0.
      b0(ib) = 0.
      go to 30
  10  if (jstrus.eq.1) go to 20
      j = 3
      b1(ib) = bb1
      b0(ib) = bb0
      go to 30
  20  if (istru.lt.25) go to 80
      j = 3
      b1(ib) = 0.
      b0(ib) = 1.
  30  go to (40, 50, 60), iscal
  40  call smimp(qmax)
      go to 70
  50  call smax(qmax, 8, 9, 1)
      go to 70
  60  call spow(qmax)
      qmax = sqrt(qmax)
  70  bmax = amax1(bmax,qmax)
      go to (90, 10, 80), j
  80  b1(ib) = bb1
      b0(ib) = bb0
  90  sca = scalm/bmax
      if (jstrus.eq.1) go to 100
      if (jstrud.eq.2) go to 100
      if (amax*sca.gt.scalm) sca = scalm/amax
c
c scaling with a power of two
c
 100  if (lpot2.ne.(-1)) go to 110
      i = alog(sca)/alog(2.)
      q = 2.**i
      if (q.gt.sca) q = q/2.
      sca = q
      go to 120
 110  if (iwlr.ge.100) go to 120
      bb0 = 2.*alsbi
      q = sca*bb0
      sca = aint(q)/bb0
 120  amax = bmax*sca
      fact = fact*sca
      nb = nnb
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   scal02
c calculate scaling factor into numerator
c-----------------------------------------------------------------------
c
      subroutine scal02
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
c
      i = ib
      if (jstrud.eq.1) go to 10
      if (i.eq.1) go to 20
      i = i - 1
  10  b2(i) = sca
      b1(i) = b1(i)*sca
      b0(i) = b0(i)*sca
      fact = fact/sca
  20  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   alns01
c allocation of the noise sources for the modified structures of the
c first and second canonic forms
c-----------------------------------------------------------------------
c
      subroutine alns01
c
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
c
      do 10 i=1,5
        aqc(i) = 1.
  10  continue
c
      bb2 = sca
      if (ib.gt.nb) go to 120
      call quan(c1(ib), aqc1)
      call quan(c0(ib), aqc0)
      bb1 = b1(ib)
      bb0 = b0(ib)
c
      j = istru/10
      if (j.eq.2) go to 130
      bb2 = bb2*b2(ib)
      call quan(bb2, aqb2)
      if (jstru.eq.2) go to 20
      bb1 = bb1*sca
      bb0 = bb0*sca
  20  call quan(bb1, aqb1)
      call quan(bb0, aqb0)
      j = istru - 10
      iis = 1
      go to (30, 30, 50, 50, 60, 70, 90, 100), j
  30  aqc(5) = aqc0
      aqc(4) = aqc1
      aqc(3) = aqb0
      aqc(2) = aqb1
  40  aqc(1) = aqb2
      go to 270
  50  aqc(4) = amin1(aqb1,aqc1)
      aqc(5) = amin1(aqb0,aqc0)
      go to 40
  60  aqc(3) = aqb0
      go to 80
  70  aqc(1) = aqb2
  80  aqc(2) = aqb1
      aqc(4) = aqc1
      aqc(5) = aqc0
      go to 270
  90  aqc(5) = amin1(aqb0,aqc0)
      go to 110
 100  aqc(5) = aqc0
 110  aqc(4) = amin1(aqb1,aqc1)
      go to 40
c
 120  aqc1 = 1.
      aqc0 = 1.
      aqb1 = 1.
      aqb0 = 1.
      go to 140
 130  j = istru - 20
      call quan(bb1, aqb1)
      call quan(bb0, aqb0)
 140  iis = 2
      if (ib.ne.1) bb2 = bb2*b2(ib-1)
      call quan(bb2, aqb2)
      go to (170, 150, 210, 200, 190, 160, 210, 220), j
 150  aqc(3) = aqb0
 160  aqc(2) = aqb1
 170  aqc(1) = aqb2
 180  aqc(4) = aqc1
      aqc(5) = aqc0
      go to 230
 190  if (ib.eq.1) go to 170
      go to 180
 200  aqc(2) = amin1(aqb1,aqb0)
 210  aqc(4) = amin1(aqb2,aqc1,aqc0)
      if (ib.le.nb) go to 230
      aqc(1) = aqc(4)
      aqc(4) = 1.
      go to 270
 220  aqc(2) = aqb1
      go to 210
c
 230  if (ib.eq.1) go to 270
      bb1 = b1(ib-1)
      bb0 = b0(ib-1)
      if (jstrus.eq.2) go to 240
      bb1 = bb1*sca
      bb0 = bb0*sca
 240  call quan(bb1, aqb1)
      call quan(bb0, aqb0)
      go to (250, 270, 260, 270, 250, 270, 260, 270), j
 250  aqc(3) = aqb0
      aqc(2) = aqb1
      go to 270
 260  aqc(4) = amin1(aqc(4),aqb1,aqb0)
c
 270  do 460 i=1,5
        bn2(i) = 0.
        bn1(i) = 0.
        bn0(i) = 0.
        if (aqc(i).eq.1.) go to 460
        if (ib.gt.nb) go to 420
        if (iis.eq.2) go to 340
        go to (280, 290, 300, 310, 320, 330, 300, 310), j
 280    go to (420, 430, 440, 430, 440), i
 290    go to (400, 430, 440, 430, 440), i
 300    go to (420, 460, 460, 430, 440), i
 310    go to (400, 460, 460, 430, 440), i
 320    go to (460, 430, 410, 430, 440), i
 330    go to (400, 430, 460, 430, 440), i
c
 340    go to (390, 350, 360, 370, 390, 380, 360, 370), j
 350    go to (390, 450, 450, 390, 390), i
 360    go to (460, 460, 460, 390, 460), i
 370    go to (460, 450, 460, 390, 460), i
 380    go to (390, 450, 460, 390, 390), i
c
 390    bn2(i) = b2(ib)
        bn1(i) = b1(ib)
        bn0(i) = b0(ib)
        go to 460
 400    bn2(i) = 1.
        bn1(i) = b1(ib)/b2(ib)
        bn0(i) = b0(ib)/b2(ib)
        go to 460
 410    bn0(i) = 1.
 420    bn2(i) = 1.
        go to 460
 430    bn1(i) = 1.
        go to 460
 440    bn0(i) = 1.
        go to 460
 450    bn2(i) = b2(ib)
        bn1(i) = b2(ib)*c1(ib)
        bn0(i) = b2(ib)*c0(ib)
 460  continue
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine: alns02
c allocation of the transfer functions from the input
c to the nonlinearities
c-----------------------------------------------------------------------
c
      subroutine alns02
c
      common /const/ pi, flma, flmi, fler
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /creno/ lcno, icno(16,5)
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
c
      nnb = nb
      if (ib.gt.nnb) go to 10
      bb2 = b2(ib)
      bb1 = b1(ib)
      bb0 = b0(ib)
  10  icor = 0
      is = istru - 10
      iis = 1
      if (is.le.8) go to 20
      iis = 2
      is = is - 10
c
  20  do 450 n=1,5
        bf2(n) = 0.
        bf1(n) = 0.
        bf0(n) = 0.
        ibb(n) = 0
        aq = aqc(n)
        if (aq.eq.1.) go to 400
        if (lcno.eq.(-1)) aq = 0.
        k = icno(ib,n)
        go to (400, 30, 400, 400, 40, 50, 400), k
  30    aq = sqrt(3.)*aq
        go to 60
  40    aq = -sqrt(3.)
        go to 60
  50    aq = sqrt(3.)*(aq-1.)
  60    if (aq.eq.0.) go to 440
        ibb(n) = ib
        if (ib.gt.nnb) go to 380
        if (iis.eq.2) go to 120
        go to (70, 70, 80, 90, 100, 110, 90, 90), is
  70    go to (200, 210, 220, 240, 250), n
  80    go to (260, 400, 400, 280, 290), n
  90    go to (200, 400, 400, 280, 290), n
 100    go to (400, 210, 220, 240, 250), n
 110    go to (200, 210, 400, 240, 250), n
c
 120    go to (130, 140, 150, 160, 170, 180, 150, 190), is
 130    go to (300, 310, 320, 340, 350), n
 140    go to (330, 360, 370, 340, 350), n
 150    go to (330, 400, 400, 380, 400), n
 160    go to (330, 390, 400, 380, 400), n
 170    go to (330, 310, 320, 340, 350), n
 180    go to (330, 360, 400, 340, 350), n
 190    go to (330, 360, 400, 380, 400), n
c
 200    q = bb2
        go to 230
 210    q = bb1
        go to 230
 220    q = bb0
 230    bf2(n) = q
        bf1(n) = q*c1(ib)
        bf0(n) = q*c0(ib)
        go to 410
 240    q = -c1(ib)
        go to 270
 250    q = -c0(ib)
        go to 270
 260    q = 1.
 270    bf2(n) = q*bb2
        bf1(n) = q*bb1
        bf0(n) = q*bb0
        go to 410
 280    bf2(n) = bb1 - bb2*c1(ib)
        bf1(n) = bb0 - bb2*c0(ib)
        go to 410
 290    bf2(n) = bb0 - bb2*c0(ib)
        bf1(n) = bb0*c1(ib) - bb1*c0(ib)
        go to 410
 300    if (ib.eq.1) go to 330
        iq = ib - 1
        ibb(n) = iq
        bf2(n) = b2(iq)
        go to 410
 310    iq = ib - 1
        ibb(n) = iq
        bf1(n) = b1(iq)
        go to 410
 320    iq = ib - 1
        ibb(n) = iq
        bf0(n) = b0(iq)
        go to 410
 330    q = 1.
        go to 230
 340    bf1(n) = -c1(ib)
        go to 410
 350    bf0(n) = -c0(ib)
        go to 410
 360    bf1(n) = bb1/bb2
        go to 410
 370    bf0(n) = bb0/bb2
        go to 410
 380    bf2(n) = 1.
        go to 410
 390    bf1(n) = bb1/bb2
        go to 370
c
 400    aq = 0.
        go to 440
c
 410    nb = ibb(n)
        if (ib.gt.nnb) go to 430
        if (nb.eq.ib) go to 420
        bb22 = b2(nb)
        bb12 = b1(nb)
        bb02 = b0(nb)
 420    b2(nb) = bf2(n)
        b1(nb) = bf1(n)
        b0(nb) = bf0(n)
 430    call spow(q)
        phi(n) = sqrt(q)
        icor = 1
        if (nb.eq.ib) go to 440
        b2(nb) = bb22
        b1(nb) = bb12
        b0(nb) = bb02
c
 440    bf2(n) = bf2(n)*aq
        bf1(n) = bf1(n)*aq
        bf0(n) = bf0(n)*aq
 450  continue
c
      if (ib.gt.nnb) go to 460
      b2(ib) = bb2
      b1(ib) = bb1
      b0(ib) = bb0
 460  nb = nnb
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   tstr01
c test routine for the structures nos. 11-28
c-----------------------------------------------------------------------
c
      subroutine tstr01
c
      common /const/ pi, flma, flmi, fler
      common /coptst/ lopts, istor
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      if (lopts.ne.1) go to 10
      if (istru.gt.20 .and. jstrus.eq.2) go to 30
  10  l = istru
      if (l.gt.20) l = l - 10
      if (l.lt.15) go to 60
      do 20 l=1,nb
        q = abs(b0(l))
        if (q.lt.flmi) q = abs(b1(l))
        if ((b2(l)-q).gt.flmi) go to 40
  20  continue
      go to 60
  30  l = 31
      go to 50
  40  l = 32
  50  call error(l)
  60  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   pcorp
c computation of the correlated noise of the block ib by a
c linearized model
c-----------------------------------------------------------------------
c
      subroutine pcorp
c
      complex zbl1, zqq, zom, z, za, zaa
      complex zphi(300)
c
      common /const/ pi, flma, flmi, fler
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /cpow/ pnu, pnc, and, itcorp
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cffunc/ phi(5), bf2(5), bf1(5), bf0(5), ibb(5), icor
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
c
      equivalence (zphi(1),pn(1,1))
c
      zbl1(zqq,a2,a1,a0) = (zqq*a2+a1)*zqq + a0
c
      fac = pnc
      if (itcorp.ge.0) go to 20
      do 10 i=1,300
        zphi(i) = cmplx(0.,0.)
  10  continue
      itcorp = 1
c
  20  pnc = 0.
      if (icor.eq.0) go to 80
      adom = pi/299.
      do 70 ll=1,300
        om = adom*float(ll-1)
        zom = cmplx(cos(om),sin(om))
        z = cmplx(fact,0.)
c
        do 30 i=1,nb
          if (i.ne.ib) z = z*zbl1(zom,b2(i),b1(i),b0(i))
          z = z/zbl1(zom,1.,c1(i),c0(i))
  30    continue
c
        if (ib.le.nb) z = z/zbl1(zom,1.,c1(ib),c0(ib))
        za = cmplx(0.,0.)
        do 60 n=1,5
          if (ibb(n).eq.0) go to 60
          if (ib.gt.nb) go to 50
          zaa = zbl1(zom,bf2(n),bf1(n),bf0(n))*zbl1(zom,bn2(n),bn1(n),
     *        bn0(n))
          zaa = zaa/phi(n)
          if (ibb(n).eq.ib) go to 40
          zaa = zaa*zbl1(zom,1.,c1(ib),c0(ib))/zbl1(zom,b2(ib),b1(ib),
     *        b0(ib))
  40      za = za + zaa
          go to 60
  50      za = za + bf2(n)
  60    continue
c
        z = z*za
        if (itcorp.eq.1) zphi(ll) = zphi(ll) + z*fac
        q = cabs(z)
        pnc = pnc + q*q
  70  continue
c
      pnc = pnc/pi/150.
  80  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   tcorp
c computation of the total correlated noise by a linearized model
c-----------------------------------------------------------------------
c
      subroutine tcorp
c
      complex zphi(300)
c
      common /const/ pi, flma, flmi, fler
      common /cpow/ pnu, pnc, and, itcorp
      common /copst2/ pn(100,2), tf(100,2), tfa(100,2)
      common /creno/ lcno, icno(16,5)
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      equivalence (zphi(1),pn(1,1))
c
      pnc = 0.
c
      do 20 i=1,nb
        do 10 j=1,5
          k = icno(i,j)
          if (k.eq.2) go to 30
          if (k.eq.5) go to 30
          if (k.eq.6) go to 30
  10    continue
  20  continue
      go to 50
c
  30  do 40 i=1,300
        q = cabs(zphi(i))
        pnc = pnc + q*q
  40  continue
c
      pnc = pnc/pi/150.
  50  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   descal
c remove scaling of second-order blocks
c-----------------------------------------------------------------------
c
      subroutine descal
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      do 10 i=1,nb
        q = b2(i)
        b2(i) = 1.
        b1(i) = b1(i)/q
        b0(i) = b0(i)/q
        fact = fact*q
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   denorm
c transform structure to structure without separate scaling factor
c-----------------------------------------------------------------------
c
      subroutine denorm
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      do 10 i=1,nb
        q = b2(i)
        b1(i) = b1(i)*q
        b0(i) = b0(i)*q
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   allo01
c allocation of numerators and denominators according to the
c allocation field  iseq(i,j)
c-----------------------------------------------------------------------
c
      subroutine allo01
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
c
      nb = nbs
      fact = sfact
      do 10 i=1,nb
        j = iseq(i,1)
        b2(i) = sb2(j)
        b1(i) = sb1(j)
        b0(i) = sb0(j)
        j = iseq(i,2)
        c1(i) = sc1(j)
        c0(i) = sc0(j)
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   allo02
c allocation of numerators and denominators according to the
c allocation field  kseq(i,j), for a given start ordering
c-----------------------------------------------------------------------
c
      subroutine allo02
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /crest2/ kseq(16,2)
c
      nb = nbs
      fact = sfact
      do 10 i=1,nb
        j = kseq(i,1)
        b2(i) = sb2(j)
        b1(i) = sb1(j)
        b0(i) = sb0(j)
        j = kseq(i,2)
        c1(i) = sc1(j)
        c0(i) = sc0(j)
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   fixpar
c fixed pairing of poles and zeros
c used together with a free input of the coefficients
c-----------------------------------------------------------------------
c
      subroutine fixpar
c
      common /const/ pi, flma, flmi, fler
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
      common /scrat/ adum(32)
c
      dimension ipol(16,2)
      equivalence (adum(1),ipol(1,1))
c
      do 10 i=1,nb
        ipol(i,1) = 0
        ipol(i,2) = 0
  10  continue
c
      do 30 i=1,nb
        pm = 0.
        do 20 j=1,nb
          if (ipol(j,1).ne.0) go to 20
          p2o = pow2o(1.0,0.,0.,c1(j),c0(j))
          if (p2o.le.pm) go to 20
          pm = p2o
          ipm = j
  20    continue
        ipol(ipm,1) = i
  30  continue
c
      do 70 i=1,nb
        do 40 k=1,nb
          if (ipol(k,1).ne.i) go to 40
          kk = k
          go to 50
  40    continue
c
  50    cc0 = c0(kk)
        cc1 = c1(kk)
        do 60 j=1,nb
          if (ipol(j,2).ne.0) go to 60
          p2o = pow2o(1.0,bb1,bb0,cc1,cc0)
          pm = p2o
          izm = j
  60    continue
        ipol(izm,2) = kk
  70  continue
c
      call copy01
      do 80 i=1,nb
        ipm = ipol(i,2)
        b2(ipm) = sb2(i)
        b1(ipm) = sb1(i)
        b0(ipm) = sb0(i)
  80  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   polloc
c calculate the poles in the closed upper z-domain
c-----------------------------------------------------------------------
c
      subroutine polloc
c
      complex zp, zps
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /cpol/ zp(16,2), zps(16,2)
c
      do 20 i=1,nb
        q = -c1(i)/2.
        qn = c0(i)
        qn = q*q - qn
        if (qn.lt.0.) go to 10
        qn = sqrt(qn)
        zps(i,1) = cmplx(q+qn,0.)
        zps(i,2) = cmplx(q-qn,0.)
        go to 20
  10    qn = sqrt(-qn)
        zps(i,1) = cmplx(q,qn)
        zps(i,2) = cmplx(q,-qn)
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c function:     pow2o
c noise power of a second-order block
c-----------------------------------------------------------------------
c
      function pow2o(b2, b1, b0, c1, c0)
c
      bb0 = b2*b2 + b1*b1 + b0*b0
      bb1 = 2.*b1*(b2+b0)
      bb2 = 2.*b2*b0
      e1 = 1. + c0
      q = bb0*e1 - bb1*c1 + bb2*(c1*c1-c0*e1)
      q = q/((1.-c0*c0)*e1-(c1-c1*c0)*c1)
      pow2o = q
      return
      end
c
c ======================================================================
c
c doredi - subroutines: part iv
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   defin1
c default values for class 01 input data
c-----------------------------------------------------------------------
c
      subroutine defin1
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /cgrid/ gr(64), ngr(12)
c
      ninp = 0
      nout = 3
      ndout = 0
      lspout = 0
      nspout = 0
      do 10 i=1,12
        ngr(i) = 0
  10  continue
      do 20 i=1,4
        rom(i) = 0.
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp010
c command cards for input and output directives
c processing of the command cards class 01
c-----------------------------------------------------------------------
c
      subroutine inp010
c
      common /contr/ iprun, ipcon, ninp, nout, ndout, lspout, nspout
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /cgrid/ gr(64), ngr(12)
c
      j = jcode/10
      if (j.eq.0) go to 110
      if (j.gt.4) go to 110
      go to (10, 80, 90, 100), j
c
c *0110  b,ninp
c
  10  if (iinp.gt.4) go to 120
      go to (20, 30, 40, 50), iinp
  20  if (ninp.eq.0) go to 130
      go to 70
  30  call inp012
      go to 70
  40  ninp = iinp
      call inp013
      go to 60
  50  ninp = iinp
      call inp014
  60  ngr(1) = 0
      return
  70  ninp = iinp
      return
c
c *0120  b,nout
c
  80  if (iinp.lt.0 .or. iinp.gt.5) go to 120
      nout = iinp
      return
c
c *0130  ndout
c
  90  ndout = linp
      return
c
c *0140  lspout,ispout
c
 100  lspout = linp
      nspout = iinp
      return
c
 110  i = 1
      go to 140
 120  i = 4
      go to 140
 130  i = 12
 140  call error(i)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp012
c input of the filter description and data from disk:(channel ka4)
c-----------------------------------------------------------------------
c
      subroutine inp012
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
9999  format (10i5)
9998  format (4e15.7)
c
      do 10 i=1,3
        read (ka4,9999)
  10  continue
      read (ka4,9999) ityp, iapro, ndeg
      read (ka4,9998) sf, om, adelp, adels
      read (ka4,9998) ac, rom, rdelp, rdels
      read (ka4,9999) nzm, m
      do 20 i=1,m
        read (ka4,9998) (zm(i,j),j=1,4)
  20  continue
      read (ka4,9999)
      read (ka4,9999) nb
      read (ka4,9998) fact
      do 30 i=1,nb
        read (ka4,9998) b2(i), b1(i), b0(i), c1(i), c0(i)
  30  continue
      read (ka4,9999) irco
      do 40 i=1,nb
        read (ka4,9999) (ieco(i,j),j=1,5)
  40  continue
      do 50 i=1,nb
        read (ka4,9999) (idco(i,j),j=1,5)
  50  continue
      read (ka4,9999) iwl, iecom, jmaxv, jtrb2
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp013
c input of second-order blocks
c-----------------------------------------------------------------------
c
      subroutine inp013
c
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      call inp001
      if (lcode.ne.0) return
      call inp002
      if (icode.ne.0 .or. jcode.ne.10) call error(2)
      nb = iinp
      fact = ainp(1)
c
      ma = 2*nb
      do 20 i=1,ma
        call inp001
        if (lcode.ne.0) return
        call inp002
        if (icode.ne.0 .or. jcode.ne.10) call error(2)
        if (i.gt.nb) go to 10
        b2(i) = ainp(1)
        b1(i) = ainp(2)
        b0(i) = ainp(3)
        go to 20
  10    j = i - nb
        c1(j) = ainp(2)
        c0(j) = ainp(3)
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp014
c input of poles and zeros
c-----------------------------------------------------------------------
c
      subroutine inp014
c
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      call inp001
      if (lcode.ne.0) return
      call inp002
      if (icode.ne.0 .or. jcode.ne.10) call error(2)
      nb = iinp
      fact = ainp(1)
      nn = 0
      jj = nb
c
  10  call inp001
      if (lcode.ne.0) return
      call inp002
      if (icode.ne.0 .or. jcode.ne.10) call error(2)
      qr = ainp(1)
      qi = ainp(2)
      if (qi.eq.0.) go to 20
      a0 = qr*qr + qi*qi
      a1 = -2.*qr
      go to 40
  20  if (jj.ne.nb) go to 30
      jj = nb - 1
      r = qr
      go to 10
  30  jj = nb
      a0 = r*qr
      a1 = -r - qr
  40  nn = nn + 1
      if (k.eq.2) go to 50
      b2(nn) = 1.
      b1(nn) = a1
      b0(nn) = a0
      go to 60
  50  c1(nn) = a1
      c0(nn) = a0
  60  if (nn.lt.jj) go to 10
      if (jj.eq.nb) go to 70
      a1 = -r
      a0 = 0.
      jj = jj + 1
      go to 40
  70  if (k.eq.2) return
      k = 2
      nn = 0
      go to 10
c
      end
c
c-----------------------------------------------------------------------
c subroutine:   defin2
c default values for the command cards of class 02
c-----------------------------------------------------------------------
c
      subroutine defin2
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest2/ kseq(16,2)
      common /coptst/ lopts, istor
c
      loptw = 0
      lstab = -1
      iwlr = 100
      acxmi = 0.
      acxma = 1.
      lopts = 0
      istor = 100
      lseq = 0
      iscal = 2
      scalm = 1.
      iterm = 10
      iterm1 = 4
      do 20 j=1,2
        do 10 i=1,mbl
          kseq(i,j) = i
          iseq(i,j) = i
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp020
c command cards for controlling the optimization
c processing of the command cards of class 02
c-----------------------------------------------------------------------
c
      subroutine inp020
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /intdat/ jinp(16)
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest2/ kseq(16,2)
      common /coptst/ lopts, istor
c
      if (jcode.lt.10) go to 110
      j = jcode/10
      if (j.gt.4) go to 110
      go to (10, 50, 60, 70), j
c
c *0210  lwlf,iterm,acx,acxmi,acxma
c
  10  loptw = -1
      if (linp.eq.(-1)) loptw = 1
      if (iinp.eq.0) go to 20
      if (iinp.lt.0) go to 120
      iterm = iinp
  20  if (npar.eq.0) go to 30
      q = ainp(1)
      if (q.lt.0. .or. q.gt.1.) go to 120
      acx = q
  30  q = ainp(2)
      if (q.eq.0.) go to 40
      if (q.lt.0. .or. q.ge.1.) go to 120
      acxmi = q
  40  q = ainp(3)
      if (q.eq.0.) return
      if (q.le.0. .or. q.gt.1.) go to 120
      acxma = q
      return
c
c *0220  b,iterm1
c
  50  if (iinp.lt.0) go to 120
      iterm1 = iinp
      return
c
c *0230  pairf,istor
c
  60  lopts = -1
      if (linp.eq.(-1)) lopts = 1
      if (iinp.gt.100) go to 120
      if (iinp.lt.0) go to 120
      if (iinp.ne.0) istor = iinp
      return
c
c *0240  lseq,iscal,scalm
c
  70  if (linp.ne.(-1)) go to 100
      lseq = -1
      do 90 j=1,2
        call inp001
        if (icode.ne.0) go to 130
        if (jcode.ne.40) go to 130
        call inp003
        do 80 i=1,mbl
          kseq(i,j) = jinp(i)
  80    continue
  90  continue
c
 100  if (iinp.ne.0) iscal = iinp
      if (iscal.lt.0) iscal = 0
      if (ainp(1).ne.0.) scalm = ainp(1)
      return
c
 110  i = 4
      go to 140
 120  i = 5
      go to 140
 130  i = 2
 140  call error(i)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   defin3
c set default values
c-----------------------------------------------------------------------
c
      subroutine defin3
c
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      ityp = 1
      iapro = 4
      ndeg = 0
      ndegf = 0
      mdeg = 0
      norma = 0
      lsout = 0
c
      do 10 i=1,4
        om(i) = 0.
  10  continue
      sf = 0.
      a = 0.
      adelp = 0.
      adels = 1./flma
      vsn = 0.
      vd = 0.
      acx = 1000.
      edeg = acx
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp030
c input routine for the filter type and for the tolerance scheme
c processing of the command cards of class 03
c-----------------------------------------------------------------------
c
      subroutine inp030
c
      common /const/ pi, flma, flmi, fler
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      som(aa) = 2.*atan(aa)
c
      j = jcode/10
      if (j.gt.7) go to 240
      go to (10, 20, 30, 40, 170, 220, 230), j
c
c *0310  b,filter type,sampling frequency
c
  10  if (iinp.ne.0) ityp = iinp
      if (ainp(1).ne.0.) sf = ainp(1)
      return
c
c *0320  b,iapro,,acx
c
  20  if (iinp.ne.0) iapro = iinp
      if (npar.ne.0) acx = ainp(1)
      return
c
c *0330  ndegf,edeg
c
  30  if (linp.eq.(-1)) ndegf = -1
      if (iinp.ne.0) ndeg = iinp
      if (npar.ne.0) edeg = ainp(1)
      return
c
c cutoff frequencies of the tolerance scheme
c
  40  k = jcode - j*10
      if (k.gt.7) go to 250
      go to (50, 50, 100, 110, 120, 140, 160), k
c
c *0341  b,b,fr(1),fr(2),<sf>    ::  frequency domain
c *0342  b,b,fr(3),fr(4),<sf>
c
  50  if (ainp(3).eq.0.) go to 70
      if (sf.ne.0.) go to 260
  60  sf = ainp(3)
  70  if (sf.eq.0.) go to 270
      q = 2.*pi/sf
      go to (80, 90), k
  80  om(1) = ainp(1)*q
      om(2) = ainp(2)*q
      return
c
  90  om(3) = ainp(1)*q
      om(4) = ainp(2)*q
      return
c
c *0343  b,b,om(1),om(2)        ::  z-domain
c
 100  om(1) = ainp(1)
      om(2) = ainp(2)
      return
c
c *0344  b,b,om(3),om(4)       ::  z-domain sec. card
c
 110  om(3) = ainp(1)
      om(4) = ainp(2)
      return
c
c *0345  b,b,s(1),s(2)         ::  s-domain
c
 120  do 130 i=1,2
        om(i) = som(ainp(i))
 130  continue
      return
c
c *0346  b,b,s(3),s(4)         :: s-domain  sec. card
c
 140  do 150 i=1,2
        om(i+2) = som(ainp(i))
 150  continue
      return
c
c *0347  b,b,vsn,vd,a           ::  normalized parameter
c
 160  vsn = ainp(1)
      vd = ainp(2)
      a = ainp(3)
      return
c
c delta p, delta s
c
 170  k = jcode - j*10
      if (k.gt.3) go to 250
      go to (180, 190, 210), k
c
c *0351  b,b,delp,dels
c
 180  adelp = ainp(1)
      adels = ainp(2)
      return
c
c *0352  b,b,ap,as (in db)
c
 190  adelp = 1. - 10.**(-0.05*ainp(1))
 200  adels = 10.**(-0.05*ainp(2))
      return
c
c *0353  b,b,p,as    (as in db)
c
 210  q = ainp(1)
      adelp = 1. - sqrt(1.-q*q)
      go to 200
c
c *0360  b,norma
c
 220  if (iinp.lt.0 .or. iinp.gt.3) go to 250
      norma = iinp
      return
c
c *0370  lsout
c
 230  lsout = linp
      return
c
c output of error messages
c
 240  i = 4
      go to 280
 250  i = 5
      go to 280
 260  i = 7
      go to 280
 270  i = 6
 280  call error(i)
      if (i.eq.7) go to 60
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp031
c check routine for the filter input data
c check data cards of class 03
c-----------------------------------------------------------------------
c
      subroutine inp031
c
      common /const/ pi, flma, flmi, fler
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      if (ityp.gt.4) go to 90
      if (iapro.gt.4) go to 100
c
      if (edeg.gt.999.) edeg = 0.2
c
c check om(1) ... om(4)
c
      lvsn = 0
      lsym = 0
      j = 0
      q = 0.
      me = 2
      if (ityp.ge.3) me = 4
      do 20 i=1,me
        qq = om(i)
        if (qq.eq.0.) go to 10
        if (qq.gt.pi) go to 120
        if (qq.lt.q) go to 110
        q = qq
        go to 20
  10    lsym = lvsn
        lvsn = i
        j = j + 1
  20  continue
      if (j.eq.0) go to 80
      if (ityp.gt.2) go to 30
      if (j.eq.1) go to 70
      go to 50
  30  go to (40, 60, 50, 50), j
  40  lsym = lvsn
      lvsn = 0
      j = 0
      go to 80
c
  50  if (vsn.eq.0.) go to 120
      if (vd.eq.0.) go to 120
      if (ityp.gt.2 .and. a.eq.0.) go to 110
      lvsn = -1
      go to 80
c
  60  j = 1
      iq = lsym + lvsn
      if (iq.le.3 .or. iq.ge.7) go to 120
  70  if (ndeg.eq.0) go to 120
c
c check for passband and stopband ripple
c
  80  if (adelp.eq.0.) j = j + 1
      if (adels.le.(1./flma)) j = j + 1
      if (j.eq.0) return
      if (j.ne.1 .or. ndeg.eq.0) go to 130
      return
c
c output of error message
c
  90  i = 20
      go to 140
 100  i = 21
      go to 140
 110  i = 22
      go to 140
 120  i = 23
      go to 140
 130  i = 24
 140  call error(i)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   defin4
c set default values for command cards of class 04
c-----------------------------------------------------------------------
c
      subroutine defin4
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
      lstab = 0
      lref = 0
      iwl = 16
      jrco = 2
      jeco = 0
      jdco = 0
      jmaxv = -3
      jtrb2 = 3
      do 20 j=1,5
        irco(j) = 0
        do 10 i=1,mbl
          ieco(i,j) = 0
          idco(i,j) = -100
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp040
c input routine for the specification of the coefficient realization
c-----------------------------------------------------------------------
c
      subroutine inp040
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /intdat/ jinp(16)
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
      j = jcode/10
      if (j.eq.0) go to 170
      if (j.gt.6) go to 170
      go to (10, 20, 50, 90, 150, 160), j
c
c *0410  lstab,iwl
c
  10  lstab = linp
      if (iinp.ne.0) iwl = iinp
      return
c
c *0420  rcoinp,jrco
c
  20  if (linp.ne.(-1)) go to 40
      call inp001
      if (lcode.eq.1) return
      call inp003
      if (icode.ne.0 .or. jcode.ne.20) call error(2)
      do 30 i=1,5
        irco(i) = jinp(i)
  30  continue
      jrco = 0
      if (iinp.ne.0) go to 180
  40  jrco = iinp
      return
c
c *0430  ecoinp,jeco
c
  50  if (linp.ne.(-1)) go to 80
      jeco = 0
      iecom = 0
      do 70 j=1,5
        call inp001
        if (lcode.eq.1) return
        call inp003
        if (icode.ne.0 .or. jcode.ne.30) call error(2)
        do 60 i=1,mbl
          iecom = max0(iecom,jinp(i))
          ieco(i,j) = jinp(i)
  60    continue
  70  continue
      return
c
  80  jeco = iinp
      return
c
c *0440  dcoinp,jdco
c
  90  if (linp.eq.(-1)) go to 120
      do 110 j=1,5
        ii = iinp/10
        m = 6 - j
        jj = iinp - 10*ii
        iinp = ii
        jjdco(m) = jj
        if (ii.ne.0) go to 110
        do 100 i=1,16
          idco(i,j) = -100
 100    continue
 110  continue
      jdco = -1
      return
c
 120  jdco = 0
      do 140 j=1,5
        call inp001
        if (lcode.eq.1) return
        call inp003
        if (icode.ne.0 .or. jcode.ne.40) call error(2)
        do 130 i=1,16
          idco(i,j) = jinp(i)
 130    continue
 140  continue
      return
c
c *0450  b,jmaxv
c
 150  jmaxv = iinp
      return
c
c *0460  b,jtrb2
c
 160  jtrb2 = iinp
      return
c
c output of error messages
c
 170  i = 1
      go to 190
 180  i = 9
 190  call error(i)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   defin5
c default values for command cards of class 05
c-----------------------------------------------------------------------
c
      subroutine defin5
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /creno/ lcno, icno(16,5)
c
      lcno = 0
      lpot2 = 0
      istru = 13
      jstru = 1
      jstrus = 1
      jstrud = 1
      iwlr = 100
      do 20 j=1,5
        do 10 i=1,mbl
          icno(i,j) = 3
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp050
c input data for the structure realization
c command cards of class 05
c-----------------------------------------------------------------------
c
      subroutine inp050
c
      common /const1/ maxdeg, iwlmi, iwlma, mbl
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /intdat/ jinp(16)
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /crest1/ jstrus, jstrud
      common /creno/ lcno, icno(16,5)
c
      j = jcode/10
      if (j.eq.0) go to 100
      if (j.gt.3) go to 100
      go to (10, 20, 90), j
c
c *0510  lpot2,istru
c
  10  lpot2 = linp
      if (iinp.eq.0) return
      if (iinp.ge.30) go to 110
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c here insert the parameters jstru,jstrus,jstrud for your structures
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      istru = iinp
      jstru = 1
      if (istru/2.eq.(istru+1)/2) jstru = 2
      jstrus = jstru
      jstrud = 1
      if (istru.ge.20) jstrud = 2
      return
c
c *0520  cnoinp,jcno
c
  20  if (linp.ne.(-1)) go to 50
      do 40 j=1,5
        call inp001
        if (lcode.ne.0) return
        call inp003
        if (icode.ne.0 .or. jcode.ne.20) call error(2)
        do 30 i=1,mbl
          icno(i,j) = jinp(i)
  30    continue
  40  continue
      if (iinp.ne.0) go to 130
      return
c
  50  if (iinp.eq.0) go to 120
      do 80 j=1,5
        ii = iinp/10
        m = 6 - j
        jj = iinp - 10*ii
        iinp = ii
        if (jj.ne.0) go to 60
        if (j.eq.1) go to 130
        jj = icno(1,m+1)
  60    do 70 i=1,16
          icno(i,m) = jj
  70    continue
  80  continue
      return
c
c *0530  lcno,iwlr
c
  90  lcno = linp
      if (iinp.lt.0) go to 110
      if (iinp.ne.0) iwlr = iinp
      return
c
 100  i = 1
      go to 140
 110  i = 5
      go to 140
 120  i = 9
      go to 140
 130  i = 4
 140  call error(i)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   defin6
c default values for the command cards of class 06
c-----------------------------------------------------------------------
c
      subroutine defin6
c
      common /const/ pi, flma, flmi, fler
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /coptst/ lopts, istor
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
c
      lopts = 0
      loptw = 0
      ipot = 0
      lnor = 0
      ipag = 2
      omlo = 0.
      omup = pi
      rmax = 1.
      rmin = -1.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp060
c command cards for the analysis
c processing of the command cards of class 06
c-----------------------------------------------------------------------
c
      subroutine inp060
c
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /coptst/ lopts, istor
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm1
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
c
      j = jcode/10
      if (j.eq.0) go to 90
      if (j.gt.6) go to 90
      go to (10, 20, 30, 60, 70, 80), j
c
c *0610  lwlm,iwl
c
  10  loptw = 1
      if (linp.eq.(-1)) loptw = -1
      if (iinp.lt.0) go to 100
      if (iinp.ne.0) iwl = iinp
      return
c
c *0620  lseq,lscal,scalm
c
  20  lopts = -1
      jcode = 40
      call inp020
      return
c
c *0630  lnor,ipag,omlo,omup,rmax
c
  30  iplot = 1
  40  lnor = linp
      if (iinp.gt.0) ipag = iinp
      if (iplot.eq.4) return
      if (npar.ne.0) omlo = ainp(1)
      q = ainp(2)
      if (q.eq.0.) go to 50
      if (q.le.omlo) go to 110
      omup = q
  50  if (ainp(3).ne.0.) rmax = ainp(3)
      return
c
c *0640  lnor,ipag,omlo,omup,rmax
c
  60  iplot = 2
      rmax = 100.
      go to 40
c
c *0650  lnor,ipag,omlo,omup
c
  70  iplot = 3
      go to 40
c
c *0660  lnor,ipag,rmin,rmax
c
  80  iplot = 4
      rmax = 1.
      if (npar.ne.0) rmin = ainp(1)
      q = ainp(2)
      if (q.eq.0.) go to 40
      if (q.le.rmin) go to 110
      rmax = q
      go to 40
c
  90  i = 1
      go to 120
 100  i = 5
      go to 120
 110  i = 10
      iplot = 0
 120  call error(i)
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp001
c read command card
c
c if 'decode' does not conform to your compiler,
c set the alternative input version
c
c eliminate the statements enclosed by the comment lines c111
c
c and replace the comment marks 'c222' with '    '
c
c-----------------------------------------------------------------------
c
      subroutine inp001
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
c111
c     common /ciofor/ iofo(3), ion
c111
c
      dimension iz1(2)
      data ipr, isl /1h*,1h//
c
9999  format (1x, 4a1)
9998  format (1x//11h data input)
c
      if (lcode.eq.(-1)) write (ka2,9998)
c
  10  continue
c111
c     read (ka1,iofo) (iz(i),i=1,ion)
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c decode is a machine-dependent function
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     decode(2,21,iz) iz1(1),iz1(2)
c111
c
      read (ka1,21) (iz1(i),i=1,2)
  21  format (2a1)
      if (iz1(1).eq.ipr) go to 30
      if (iz1(1).eq.isl .and. iz1(2).eq.isl) go to 20
      call error(1)
      go to 10
  20  continue
c111
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c decode is a machine-dependent function
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     decode (4,22,iz) icode,jcode
c111
c
      read (ka1,22) icode,jcode
  22  format (2x, 2a1)
      write (ka2,9999) iz1(1), iz1(2), icode, jcode
      lcode = 1
      return
  30  lcode = 0
      icode = 0
      return
c
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp002
c decode command card
c
c if 'decode' does not conform to your compiler, see inp001
c
c-----------------------------------------------------------------------
c
      subroutine inp002
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /card/ lcode, iz(40)
      common /inpdat/ icode, jcode, linp, iinp, ainp(3), npar
      common /scrat/ adum(32)
      dimension izz(15)
      equivalence (adum(1),izz(1))
c
      data ibl, it /1h ,1ht/
c
      npar = 0
c111
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c decode is a machine-dependent function
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     decode (30,11,iz) izz
c 11  format (15x, 15a1)
c     do 10 i=1,15
c       if (izz(i).ne.ibl) npar = 1
c 10  continue
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c decode is a machine-dependent function
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     decode (60,12,iz) icode,jcode,jinp,iinp,ainp
c111
c
      read (ka1,12) icode,jcode,jinp,iinp,(ainp(i),i=1,3)
      npar=1
c
      write (ka2,9999) icode, jcode, jinp, iinp, ainp
c
  12  format (1x, 2i2, 2x, 1a1, i6, 1x, 3e15.0)
9999  format (2h *, 2i4, 2x, 1a1, i6, 1x, 3e15.6)
c
      linp = 0
      if (jinp.eq.it) linp = -1
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   inp003
c integer data input
c
c
c if 'decode' does not conform to your compiler, see inp001
c-----------------------------------------------------------------------
c
      subroutine inp003
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /card/ lcode, iz(40)
      common /intdat/ jinp(16)
c
  12  format (1x, 2i2, 3x, 16i4)
9999  format (1h*, 2i3, 1x, 16i4)
c111
c
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c decode is a machine-dependent function
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     decode (72,12,iz) icode,jcode,(jinp(i),i=1,16)
c111
c
      read (ka1,12) icode,jcode,(jinp(i),i=1,16)
c
      write (ka2,9999) icode, jcode, jinp
      return
      end
c
c ======================================================================
c
c doredi - subroutines: part v
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   out010
c leader to out011 for structures with separate scaling
c-----------------------------------------------------------------------
c
      subroutine out010
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      write (ka2,9999)
9999  format (1x//46h structure with separate scaling factors b2(l)//
     *    45h for structures 21 to 28  b2(0) = gain factor)
c
      do 10 i=1,nb
        q = b2(i)
        b1(i) = b1(i)/q
        b0(i) = b0(i)/q
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out011
c output of blocks of second order
c-----------------------------------------------------------------------
c
      subroutine out011
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      write (ka2,9999) fact
9999  format (//23h blocks of second order//24h constant gain factor = ,
     *    e15.7//3h  l, 5x, 5hb2(l), 8x, 5hb1(l), 8x, 5hb0(l), 10x,
     *    5hc1(l), 8x, 5hc0(l)/)
      write (ka2,9998) (i,b2(i),b1(i),b0(i),c1(i),c0(i),i=1,nb)
9998  format (i3, 3f13.8, 2x, 2f13.8)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out012
c output of the results to the disk: (channel ka4)
c-----------------------------------------------------------------------
c
      subroutine out012
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /creco/ jrco, jeco, jdco, jjdco(5), jmaxv, jtrb2, lref
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
9999  format (10i5)
9998  format (4e15.7)
c
      write (ka4,9997)
9997  format (19h filter description)
      write (ka4,9999) ityp, iapro, ndeg
      write (ka4,9998) sf, om, adelp, adels
      write (ka4,9998) ac, rom, rdelp, rdels
      m = 0
      do 10 i=1,4
        m = max0(m,nzm(i))
  10  continue
      write (ka4,9999) nzm, m
      do 20 i=1,m
        write (ka4,9998) (zm(i,j),j=1,4)
  20  continue
      write (ka4,9996)
9996  format (5h data)
      write (ka4,9999) nb
      write (ka4,9998) fact
      do 30 i=1,nb
        write (ka4,9998) b2(i), b1(i), b0(i), c1(i), c0(i)
  30  continue
      write (ka4,9999) irco
      do 40 i=1,nb
        write (ka4,9999) (ieco(i,j),j=1,5)
  40  continue
      do 50 i=1,nb
        write (ka4,9999) (idco(i,j),j=1,5)
  50  continue
      write (ka4,9999) iwl, iecom, jmaxv, jtrb2
      write (ka4,9995)
9995  format (12h end of data)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out016
c output of blocks of second order in the s-domain
c-----------------------------------------------------------------------
c
      subroutine out016
c
      common /const/ pi, flma, flmi, fler
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      common /scrat/ adum(32)
      dimension nze(16)
      equivalence (adum(1),nze(1))
c
      write (ka2,9999) sfa
9999  format (//39h blocks of second order in the s-domain//9h constant,
     *    15h gain factor = , e15.7//3h  l, 5x, 5ha2(l), 8x, 5ha1(l),
     *    8x, 5ha0(l), 10x, 5hd1(l), 8x, 5hd0(l)/)
c
      n = 0
      me = nzm(4)
      do 10 i=1,me
        nze(i) = nzero(i)
  10  continue
      nb = (ndeg+1)/2
      ii = 1
      nz = nze(ii)
c
      do 180 i=1,nb
  20    if (nz.gt.0) go to 30
        ii = ii + 1
        nz = nze(ii)
        go to 20
  30    qi = sm(ii,4)
        if (nz.eq.1) go to 70
        if (qi.ge.flma) go to 50
  40    b2 = 1.
        b1 = 0.
        b0 = qi*qi
        go to 60
  50    b2 = 0.
        b1 = 0.
        b0 = 1.
  60    nz = nz - 2
        go to 130
  70    if (ii.eq.me) go to 120
        ma = ii + 1
        do 80 j=ma,me
          if (sm(j,4).ge.flma) go to 90
          if (sm(j,4).le.flmi) go to 100
  80    continue
        go to 120
  90    nze(j) = nze(j) - 1
        if (qi.ge.flma) go to 50
        go to 110
 100    nze(j) = nze(j) - 1
        if (qi.le.flmi) go to 40
 110    b2 = 0.
        b1 = 1.
        b0 = 0.
        nz = nz - 1
        go to 130
 120    if (qi.ge.flma) go to 50
        go to 110
c
 130    n = n + 1
        qr = spr(n)
        qi = spi(n)
        if (abs(qi).lt.flmi) go to 140
        c1 = -2.*qr
        c0 = qr*qr + qi*qi
        go to 170
 140    if (n.ge.nj) go to 150
        if (abs(spi(n+1)).lt.flmi) go to 160
 150    c1 = -qr
        c0 = 0.
        go to 170
 160    n = n + 1
        qi = spr(n)
        c1 = -qr - qi
        c0 = qr*qi
c
 170    write (ka2,9998) i, b2, b1, b0, c1, c0
9998    format (i3, 3f13.8, 2x, 2f13.8)
 180  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out022
c output of the termination kind
c-----------------------------------------------------------------------
c
      subroutine out022
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm2
      common /coptcp/ is1, is2, iabo, iwlgs, iwlgn, iwlgp, adepss,
     *    adepsn, adepsp, acxs, acxn, acxp
c
      write (ka2,9999) iter
9999  format (///38h optimization is terminated after the , i4,
     *    6h. step)
      go to (10, 20, 30), iabo
  10  write (ka2,9998)
9998  format (25h three unsuccessful steps)
      go to 40
  20  write (ka2,9997)
9997  format (24h maximum number of steps)
      go to 40
  30  write (ka2,9996)
9996  format (54h optimization parameter is coming to the end of the re,
     *    4hgion)
  40  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out023
c output of the iteration number
c-----------------------------------------------------------------------
c
      subroutine out023
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /coptco/ loptw, lstab, acxmi, acxma, iter, iterm, iterm2
c
      write (ka2,9999) iter
9999  format (1x////1x, i3, 13h-th iteration)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out025
c output of the optimization options
c-----------------------------------------------------------------------
c
      subroutine out025
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /coptst/ lopts, istor
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /creno/ lcno, icno(16,5)
c
      dimension ies(4), no(4)
      data ies(1), ies(2), ies(3), ies(4) /1h ,1hy,1he,1hs/
      data no(1), no(2), no(3), no(4) /1h ,1h ,1hn,1ho/
c
      if (lopts.eq.0) go to 10
      write (ka2,9999)
9999  format (1x//41h optimization of the pairing and ordering//)
      write (ka2,9998) istor
9998  format (46h storage for the intermediate results  istor =, i4/)
      if (lopts.eq.(-1)) write (ka2,9997) no
      if (lopts.ne.(-1)) write (ka2,9997) ies
9997  format (/14h fixed pairing, 32x, 4a1)
c
  10  write (ka2,9996) istru
9996  format (1x/20h realized structure , 19x, 7histru =, i4/)
      write (ka2,9995) iscal
9995  format (/16h scaling  option, 23x, 7hiscal =, i4)
      if (lpot2.eq.(-1)) write (ka2,9994) ies
      if (lpot2.ne.(-1)) write (ka2,9994) no
9994  format (10x, 24hby a factor of power two, 12x, 4a1)
      write (ka2,9993) scalm
9993  format (10x, 21hchosen maximum of the/10x, 15hoverflow points,
     *    14x, 7hscalm =, f6.3/)
      write (ka2,9992)
9992  format (/33h realization of the coefficients )
      if (lcno.eq.(-1)) write (ka2,9991) no, iwlr
      if (lcno.ne.(-1)) write (ka2,9991) ies, iwlr
9991  format (5x, 33hconsideration of the quantization, 8x, 4a1/5x,
     *    10hwordlength, 24x, 7hiwlr  =, i4/24x, 19h(for iwlr=100 no ro,
     *    7hunding)/)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out026
c output of the noise values of the second-order blocks
c-----------------------------------------------------------------------
c
      subroutine out026
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /crest/ istru, iscal, scalm, iseq(16,2), lseq, iwlr,
     *    lpot2, jstru
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /creno/ lcno, icno(16,5)
      common /cpow/ pnu, pnc, and, itcorp
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      dimension ncha(5), nquan(5)
c
      if (ib.le.0) go to 50
      if (ib.eq.1) write (ka2,9999)
9999  format (1x//47h num  den   scaling   uncor. noise   cor. noise,
     *    14h     dc-offset, 12h cha co-quan)
      alog2 = alog(2.)
      if (ib.gt.nb) go to 10
      ii = ib
      in = iseq(ib,1)
      id = iseq(ib,2)
      go to 20
  10  in = 0
      id = 0
      ii = nb
  20  do 40 j=1,5
        q = aqc(j)
        if (q.eq.1.) go to 30
        q = alog(q)/alog2
        nquan(j) = -ifix(q-0.5)
        ncha(j) = icno(ii,j)
        go to 40
  30    nquan(j) = 0
        ncha(j) = 0
  40  continue
      write (ka2,9998) in, id, sca, pnu, pnc, and, (ncha(j),nquan(j),j=
     *    1,5)
9998  format (/1x, 2(i3, 2x), f9.6, 1x, 3e13.5, 2i4, 4h bit/(60x, 2i4,
     *    4h bit))
      return
c
  50  write (ka2,9997) and
9997  format (46x, 14(1h-)/46x, e14.5/)
      q = and*and
      pnt = pnu + pnc + q
      write (ka2,9996) pnu, pnc, q, pnt
9996  format (12h total noise, 9x, 3e13.5, 1h=, e11.4)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out027
c output of the different noise values
c-----------------------------------------------------------------------
c
      subroutine out027
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /cnoise/ ri, rin, re, ren, fac
c
      anp = ri/12.
      alanp = 10.*alog10(anp)
      write (ka2,9999) anp, alanp
9999  format (1h //22h absolute output noise, 7x, 3hanp, 3x, 1h=,
     *    e13.5, 12h  (q*q)    =, f6.2, 3h db/)
      write (ka2,9998) fac
9998  format (/22h scaling at the output, 7x, 3hsca, 3x, 1h=, e13.5/)
      rnp = rin/12.
      alrnp = 10.*alog10(rnp)
      write (ka2,9997) rnp, alrnp
9997  format (/22h relative output noise, 7x, 3hrnp, 3x, 1h=, e13.5,
     *    12h  (q*q)    ,f6.2, 3h db)
      write (ka2,9995)
      alrin = 10.*alog10(rin)
      write (ka2,9996) rin, alrin
9996  format (/19h inner noise figure, 10x, 3hrin, 3x, 1h=, e13.5,
     *    12h (q*q)/12 = , f6.2, 3h db)
      write (ka2,9995)
9995  format (/23h related to max /h/ = 1/)
      write (ka2,9994) ren
9994  format (/22h entrance noise figure, 7x, 3hren, 3x, 1h=, e13.5/)
      write (ka2,9995)
      adw = rin/(1.+ren)
      adw = alog(adw)/(2.*alog(2.))
      idw = ifix(adw)
      q = float(idw)
      if (q.lt.adw) idw = idw + 1
      write (ka2,9993) adw, idw
9993  format (/22h additional wordlength, 6x, 11hdelta w = /, f7.3,
     *    4h/ = , i4/)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out030
c output of the tolerance scheme
c-----------------------------------------------------------------------
c
      subroutine out030
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /const/ pi, flma, flmi, fler
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
c
      dimension fe(4)
c
      al(adel) = -20.*alog10(adel)
c
      me = 2
      if (ityp.gt.2) me = 4
      write (ka2,9999)
9999  format (//17h tolerance scheme)
      write (ka2,9998)
9998  format (//13h filter-type )
      go to (10, 20, 30, 40), ityp
  10  write (ka2,9997)
9997  format (25x, 7hlowpass)
      go to 50
  20  write (ka2,9996)
9996  format (25x, 8hhighpass)
      go to 50
  30  write (ka2,9995)
9995  format (25x, 8hbandpass)
      go to 50
  40  write (ka2,9994)
9994  format (25x, 8hbandstop)
  50  write (ka2,9993)
9993  format (/15h approximation )
      go to (60, 70, 80, 90), iapro
  60  write (ka2,9992)
9992  format (25x, 11hbutterworth)
      go to 100
  70  write (ka2,9991)
9991  format (25x, 11hchebyshev i)
      go to 100
  80  write (ka2,9990)
9990  format (25x, 12hchebyshev ii)
      go to 100
  90  write (ka2,9989)
9989  format (25x, 8helliptic)
c
 100  if (sf.eq.0.) go to 120
      write (ka2,9988) sf
9988  format (/18h sampling freq.   , f15.6)
      q = sf*0.5/pi
      do 110 i=1,me
        fe(i) = om(i)*q
 110  continue
      write (ka2,9987) (fe(i),i=1,me)
9987  format (20h cutoff frequencies , 4f13.6)
c
 120  write (ka2,9986) (om(i),i=1,me)
9986  format (/20h norm. cutoff freq. , 4f13.6)
      do 130 i=1,me
        q = om(i)*0.5
        fe(i) = sin(q)/cos(q)
 130  continue
      write (ka2,9985) (fe(i),i=1,me)
9985  format (/20h cutoff freq. s-dom., 4f13.6)
      p = 1. - adelp
      q = al(p)
      p = sqrt(1.-p*p)
      write (ka2,9984) adelp, q, p
9984  format (//20h passband ripple(s) , f15.6, f12.4, 9h db   p =,
     *    f12.4)
      q = flma
      if (adels.gt.0.) q = al(adels)
      write (ka2,9983) adels, q
9983  format (20h stopband ripple(s) , f15.6, f12.4, 3h db)
      if (ndeg.eq.0) return
      write (ka2,9982) ndeg
9982  format (//32h filter degree assigned to order, i3)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out031
c output of the normalized parameter in the s-domain
c-----------------------------------------------------------------------
c
      subroutine out031
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
c
      write (ka2,9999)
9999  format (//37h normalized parameter in the s-domain)
      write (ka2,9998) vd, vsn
9998  format (/3h vd, 6x, 1h=, f13.6/4h vsn, 5x, 1h=, f13.6)
      if (ityp.le.2) return
c
      write (ka2,9997) a
9997  format (2h a, 7x, 1h=, f13.6)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out032
c output of the realized cutoff frequencies
c-----------------------------------------------------------------------
c
      subroutine out032
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
c
      me = 2
      if (ityp.ge.3) me = 4
      write (ka2,9999) (rom(i),i=1,me)
9999  format (/9h realized/20h norm. cutoff freq. , 4f13.6)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out033
c output of the filter degree
c-----------------------------------------------------------------------
c
      subroutine out033
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolsn/ vsn, vd, a
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
c
      q = adeg*edeg
      write (ka2,9999) adeg, q, ndeg
9999  format (//20h min. filter degree , f12.4//18h degree extension ,
     *    f14.4//20h chosen filter deg. , i7)
      if (ityp.le.2) return
      iq = 2*ndeg
      write (ka2,9998) iq
9998  format (26h for the reference lowpass//21h actual filter degree,
     *    i6)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out034
c output of the characteristic function  /k(jv)/**2
c-----------------------------------------------------------------------
c
      subroutine out034
c
      double precision dsk(16), dk, dks, dcap02, dcap04
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /tolcha/ gd1, gd2, acap12, adelta, adeg
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
      common /resin2/ dk, dks, dcap02, dcap04
      equivalence (pren(1),dsk(1))
c
      write (ka2,9999) adelta
9999  format (/11h cap. delta, 10x, f15.6)
      if (iapro.lt.4) return
      write (ka2,9998)
9998  format (//50h zeros of the characteristic function  /k(j*v)/**2/)
      ip = 0
      iz = 2
      zim = 0.
      do 10 i=1,nj
        zre = sngl(dsk(i))
        call out002
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out035
c output of the tolerance
c output of the bound pair of the design parameter ac
c-----------------------------------------------------------------------
c
      subroutine out035
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      write (ka2,9999) ugc, ogc
9999  format (//38h bound pair of the design parameter c , f9.4,
     *    16h  .le.  c  .le. , f9.4)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out036
c output of the zeros and poles of the normalized reference lowpass
c-----------------------------------------------------------------------
c
      subroutine out036
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /const/ pi, flma, flmi, fler
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      nz = nzm(4)
      if (iz.ne.0) go to 10
      write (ka2,9999)
9999  format (////50h poles and zeros of the normalized reference lowpa,
     *    18hss in the s-domain)
      if (ip.ne.0) nz = 0
      go to 20
  10  write (ka2,9998)
9998  format (////50h poles and zeros of the reference filter in the s-,
     *    6hdomain)
  20  continue
      pre = sfa
      call out001
      me = max0(nz,nj)
      do 60 i=1,me
        if (ip.eq.0) go to 30
        ip = 2
        q = spi(i)
        if (abs(q).lt.flmi) ip = 1
        pre = spr(i)
        pim = q
        if (nz.lt.i) go to 40
        if (nj.lt.i) ip = 0
  30    iz = nzero(i)
        zre = 0.
        zim = sm(i,4)
        go to 50
  40    iz = 0
  50    call out002
  60  continue
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out037
c output of the chosen design parameter
c-----------------------------------------------------------------------
c
      subroutine out037
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /tol/ ityp, iapro, ndeg, om(4), sf, adelp, adels
      common /design/ ndegf, edeg, acx, norma, lsout, lvsn, lsym
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
c
      write (ka2,9999) acx, ac
9999  format (/26h chosen design par.   cx =, f10.7, 10h  (=)  c =,
     *    f15.7)
      qp = 100.*rdelp/adelp
      qs = 100.*rdels/adels
      write (ka2,9998) rdelp, qp, rdels, qs
9998  format (/40h utilization of the passband  delta p  =, f10.7,
     *    3h  =, f10.5, 8h percent/20x, 20hstopband  delta s  =, f10.7,
     *    3h  =, f10.5, 8h percent)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out038
c output of the poles and zeros in the z-domain
c-----------------------------------------------------------------------
c
      subroutine out038
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /outdat/ ip, pre, pim, iz, zre, zim
      common /const/ pi, flma, flmi, fler
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
      common /resin1/ pren(16), pimn(16), ugc, ogc, ack, nj, nh
c
      write (ka2,9999)
9999  format (////32h poles and zeros in the z-domain)
      nz = nzm(4)
      pre = zfa
      call out001
      me = max0(nj,nz)
c
      do 30 i=1,me
        ip = 2
        q = zpi(i)
        if (abs(q).lt.flmi) ip = 1
        pre = zpr(i)
        pim = q
        if (nj.lt.i) ip = 0
        if (nz.lt.i) go to 10
        iz = nzero(i)
        zre = zzr(i)
        zim = zzi(i)
        go to 20
  10    iz = 0
  20    call out002
  30  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out039
c output of the extrema of the magnitude of the transfer function
c-----------------------------------------------------------------------
c
      subroutine out039
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /const/ pi, flma, flmi, fler
      common /res/ ac, rom(4), rdelp, rdels, nzm(4)
      common /ress/ sfa, sm(18,4), nzero(16), spr(16), spi(16)
      common /resz/ zfa, zm(18,4), zzr(16), zzi(16), zpr(16), zpi(16)
c
      write (ka2,9999)
9999  format (///51h extremes of the magnitude of the transfer function,
     *    1h , 20h(coefs not rounded) )
      fn = 180./pi
      write (ka2,9998)
9998  format (/1x, 26hmaxima in the passband (p)/1x, 15hmaxima in the s,
     *    11htopband (s)/14hband  s-domain, 7x, 8hz-domain, 10x,
     *    9hmagnitude/17x, 6hin rad, 3x, 9hin degree/)
c
      ii = 1
      jj = 3
  10  i = nzm(ii)
      j = nzm(jj)
      k = max0(i,j)
      do 40 l=1,k
        if (i.lt.l) go to 20
        omeg1 = fn*zm(l,ii)
        amag1 = amago(zm(l,ii))
        if (j.lt.l) go to 30
        omeg2 = fn*zm(l,jj)
        amag2 = amago(zm(l,jj))
        write (ka2,9997) sm(l,ii), zm(l,ii), omeg1, amag1, sm(l,jj),
     *      zm(l,jj), omeg2, amag2
9997    format (1hp, 3(f10.4, 2x), f12.6/1hs, 3(f10.4, 2x), f12.6)
9996    format (1hp, 3(f10.4, 2x), f12.6)
        go to 40
  20    omeg2 = fn*zm(l,jj)
        amag2 = amago(zm(l,jj))
        write (ka2,9995) sm(l,jj), zm(l,jj), omeg2, amag2
9995    format (1hs, 3(f10.4, 2x), f12.6)
        go to 40
  30    write (ka2,9996) sm(l,ii), zm(l,ii), omeg1, amag1
  40  continue
      if (ii.eq.2) return
      write (ka2,9994)
9994  format (/1x, 26hminima in the passband (p)/1x, 15hminima in the s,
     *    11htopband (s)/14hband  s-domain, 7x, 8hz-domain, 10x,
     *    9hmagnitude/17x, 6hin rad, 3x, 9hin degree/)
      ii = 2
      jj = 4
      go to 10
c
      end
c
c-----------------------------------------------------------------------
c subroutine:   out042
c output of the start grid for the search of the global extrema
c of the transfer function
c-----------------------------------------------------------------------
c
      subroutine out042
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /cgrid/ gr(64), ngr(12)
c
      write (ka2,9999)
9999  format (///36h grid for the search of the extremes)
      j = 1
      if (ngr(1).ne.0) go to 10
      ma = ngr(8)
      me = ngr(9)
      j = 4
  10  go to (20, 30, 40, 50, 80), j
  20  write (ka2,9998)
9998  format (/10h pass band/)
      ma = 1
      me = ngr(3)
      go to 60
  30  ma = me + 1
      me = ngr(5)
      if (me.lt.ma) go to 70
      go to 60
  40  write (ka2,9997)
9997  format (/10h stop band/)
      ma = max0(ngr(3),ngr(5)) + 1
      me = ngr(6)
      go to 60
  50  ma = me + 1
      me = ngr(7)
      if (me.lt.ma) go to 80
  60  write (ka2,9996) (gr(i),i=ma,me)
9996  format (7f10.4)
  70  j = j + 1
      go to 10
  80  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out043
c head line for the search of the minimum wordlength
c-----------------------------------------------------------------------
c
      subroutine out043
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
c
      write (ka2,9999)
9999  format (//29h search of minimum wordlength//4h iwl, 6x, 5heps-p,
     *    7x, 5heps-s, 7x, 4hpmax)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out044
c output of error epsilon and maximum magnitude
c-----------------------------------------------------------------------
c
      subroutine out044
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /cepsil/ eps(2), pmax
c
9999  format (i4, 3f12.6)
c
      write (ka2,9999) iwl, eps, pmax
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out045
c output of minimum wordlength
c-----------------------------------------------------------------------
c
      subroutine out045
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
c
      write (ka2,9999) iwlg, adepsg, iwld, adepsd
9999  format (/19h minimum wordlength, i4, 13h  delta eps =,
     *    f12.6/19h test    wordlength, i4, 13h  delta eps =, f12.6)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out046
c output of the layout of the rounded coefficients
c-----------------------------------------------------------------------
c
      subroutine out046
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /const/ pi, flma, flmi, fler
      common /ccoefw/ iwl, iwlg, iwld, iwll, adepsg, adepsd, adepsl,
     *    istab, idepsl, idepsd
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /filtre/ irco(5), ieco(16,5), idco(16,5), iecom
      common /scrat/ adum(32)
c
      dimension aco(16,5)
      dimension itext(5), jtext(5)
      dimension ioct(12)
      equivalence (b2(1),aco(1,1))
      equivalence (adum(1),ioct(1))
c
      data itext(1), itext(2), itext(3), itext(4), itext(5) /1hb,1hb,
     *    1hb,1hc,1hc/
      data jtext(1), jtext(2), jtext(3), jtext(4), jtext(5) /1h2,1h1,
     *    1h0,1h1,1h0/
c
      write (ka2,9999) iwl
9999  format (///35h layout of the rounded coefficients//11h wordlength,
     *    2h  , i4///11x, 4hcoef, 10x, 5hcoefs, 10x, 2hir, 3x, 2hie,
     *    10x, 2hid, 5x, 5hoctal/)
      do 20 j=1,5
        write (ka2,9998)
9998    format (/)
        do 10 i=1,nb
          ac = aco(i,j)
          acs = acoefs(ac,ieco(i,j),idco(i,j),irco(j))
          id = sign(2.,ac)
          q = acs
          call octal(q, ioct, 12)
          write (ka2,9997) itext(j), jtext(j), i, ac, acs, irco(j),
     *        ieco(i,j), id, idco(i,j), (ioct(ii),ii=1,12)
9997      format (2a1, 1h(, i2, 2h) , f13.8, 1h=, f13.8, 5h*2**(, i3,
     *        2h -, i3, 1h), 2x, i3, 2h**, i4, 1x, 12i1)
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out060
c new page
c-----------------------------------------------------------------------
c
      subroutine out060
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      write (ka2,9999)
9999  format (1h1)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out061
c head of printer plot
c-----------------------------------------------------------------------
c
      subroutine out061
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /cline/ y, x, iz(111)
      dimension a(6)
      equivalence (a(1),iz(1))
      go to (10, 20, 30, 40), iplot
  10  write (ka2,9999)
9999  format (1h /30x, 35hmagnitude of the frequency response/)
      go to 50
  20  write (ka2,9998)
9998  format (1h /28x, 37hattenuation of the frequency response/)
      go to 50
  30  write (ka2,9997)
9997  format (1h /31x, 14hphase response/)
      go to 50
  40  write (ka2,9996)
9996  format (1h /31x, 16himpulse response/)
  50  write (ka2,9995) a(1), a(3), a(5)
9995  format (9hmagnitude, 2x, 1hx, f8.3, 2(11x, f9.3)/)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out062
c output of the plotter line
c-----------------------------------------------------------------------
c
      subroutine out062
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /cplot/ iplot, lnor, ipag, omlo, omup, rmax, rmin
      common /cline/ y, x, iz(111)
      dimension izdum(56)
      data ichp, ichb /1h+,1h /
      do 10 i=1,110,2
        j = (i+1)/2
        izdum(j) = ichb
        if (iz(i).ne.ichb) izdum(j) = iz(i)
        if (iz(i+1).ne.ichb) izdum(j) = iz(i+1)
        if ((iz(i).eq.ichp) .or. (iz(i+1).eq.ichp)) izdum(j) = ichp
  10  continue
      izdum(56) = iz(111)
      if (iplot.eq.4) go to 20
      write (ka2,9999) y, x, izdum
9999  format (e9.3, f6.3, 1x, 56a1)
      go to 30
  20  ix = int(x)
      write (ka2,9998) y, ix, izdum
9998  format (e9.3, i6, 1x, 56a1)
  30  return
      end
c
c-----------------------------------------------------------------------
c subroutine:   head
c output of a head line
c-----------------------------------------------------------------------
c
      subroutine head(kan)
c
      write (kan,9999)
9999  format (41h     ===  doredi  ===  version  v005 === )
c
c here on line for the output of date and time;
c remove the following statement
      write (kan,9998)
9998  format (1h )
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out001
c headline of the poles and zero output
c-----------------------------------------------------------------------
c
      subroutine out001
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /outdat/ ip, pre, pim, iz, zre, zim
c
      if (pre.ne.0.) write (ka2,9999) pre
9999  format (/24h constant gain factor = , e15.7)
      write (ka2,9998)
9998  format (//3x, 4hnum., 11x, 5hpoles, 15x, 4hnum., 11x, 5hzeros/)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   out002
c output of pole and zero
c-----------------------------------------------------------------------
c
      subroutine out002
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
      common /outdat/ ip, pre, pim, iz, zre, zim
c
      if (ip.eq.0) go to 20
      if (iz.eq.0) go to 10
      write (ka2,9999) ip, pre, pim, iz, zre, zim
9999  format (2(1x, i5, 1x, f11.6, 5h +-j*, f11.6, 1x))
      return
  10  write (ka2,9999) ip, pre, pim
      return
  20  if (iz.eq.0) return
      write (ka2,9998) iz, zre, zim
9998  format (36x, i5, 1x, f11.6, 5h +-j*, f11.6, 1x)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   octal
c octal conversion
c-----------------------------------------------------------------------
c
      subroutine octal(ac, ioct, n)
c
      common /const/ pi, flma, flmi, fler
c
      dimension ioct(1)
c
      bc = ac
      if (bc.lt.(-1.0)) bc = -1.0
      if (bc.lt.0.) bc = -bc
      if (bc.ge.1.) bc = 0.
c
      ioct(1) = 0
      do 10 j=2,n
        q = 8.*bc
        iq = int(q)
        ioct(j) = iq
        bc = q - float(iq)
  10  continue
c
      if (ac.ge.flmi) return
      ia = 1
      ioct(1) = 1
      iq = n - 1
      do 20 j=1,iq
        jj = n - j + 1
        if (ia.eq.1 .and. ioct(jj).eq.0) go to 20
        ioct(jj) = 7 - ioct(jj) + ia
        ia = 0
  20  continue
c
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   outspe
c     dummy subroutine for 'special output'
c-----------------------------------------------------------------------
c
      subroutine outspe
c
      common /contr / iprun,ipcon,ninp,nout,ndout,lspout,ispout
      common /canpar/ ka1,ka2,ka3,ka4,ka5,line
c
c     data transfer by named common blocks:
c
      common /filt  / nb,fact,b2(16),b1(16),b0(16),c1(16),c0(16)
c
c     ispmax: maximum number of implemented options
      ispmax=0
c
      if(ispout.le.0) return
      if(ispout.gt.ispmax) go to 900
c
c     example for ispmax=3
c
c     go to (100,200,300),ispout
c 100 continue
c     .
c     option no.  1
c     .
c     return
c
c 200 continue
c     .
c     option no.  2
c     .
c     return
c
c 300 continue
c     .
c     option no.  3
c     .
c     return
c
  900 call error (8)
      return
      end
c
c ======================================================================
c
c doredi - subroutines: part vi
c
c ======================================================================
c
c
c-----------------------------------------------------------------------
c subroutine:   spow
c calculation of the l-2 norm
c-----------------------------------------------------------------------
c
      subroutine spow(bmax)
c
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cpow/ pnu, pnc, and, itcorp
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /creno/ lcno, icno(16,5)
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      bb2 = bn2(1)
      bb1 = bn1(1)
      bb0 = bn0(1)
      bn2(1) = b2(1)
      bn1(1) = b1(1)
      bn0(1) = b0(1)
      lq = lcno
      lcno = 2
      iq = ib
      ib = 1
      q = pnu
      call power
      bmax = pnu*fact*fact
      pnu = q
      ib = iq
      lcno = lq
      bn2(1) = bb2
      bn1(1) = bb1
      bn0(1) = bb0
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   power
c calculation of the noise power generated in the ib-th block
c-----------------------------------------------------------------------
c
      subroutine power
c
      complex za, zb, zp, zps, zq, zqi, z0, z1, zbl, zbl1, zz, zz1
c
      common /const/ pi, flma, flmi, fler
      common /cpol/ zp(16,2), zps(16,2)
      common /creno/ lcno, icno(16,5)
      common /cnfunc/ aqc(5), bn2(5), bn1(5), bn0(5)
      common /cpow/ pnu, pnc, and, itcorp
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      dimension eu(5)
c
      data z0,z1 /(0.,0.),(1.,0.)/
c
      zbl(zz,a1,a0) = (zz+a1)*zz + a0
      zbl1(zz1,a21,a11,a01) = (a21*zz1+a11)*zz1 + a01
c
      za = z0
      pnu = 0.
      if (lcno.ne.2) go to 20
      eu(1) = 1.
      do 10 i=2,5
        eu(i) = 0.
  10  continue
      go to 160
  20  do 130 n=1,5
        aq = aqc(n)
        if (aq.eq.1.) go to 120
        if (lcno.eq.(-1)) aq = 0.
        kk = ib
        if (kk.gt.nb) kk = nb
        k = icno(kk,n)
        qs = 1.
        qc1 = 0.
        go to (30, 40, 50, 60, 70, 80, 90), k
  30    qc2 = -1.
        q = aq/2.
        go to 100
  40    qc2 = 2.*(1.-3./pi)
        go to 110
  50    qc2 = 2.
        go to 110
  60    qc2 = -1.
        q = (aq-1.)/2.
        go to 100
  70    qs = 4. - 6./pi
        go to 30
  80    qc1 = -6.*(1.-2./pi)
        go to 40
  90    qs = 4.
        go to 30
 100    za = za + q*zbl1(z1,bn2(n),bn1(n),bn0(n))
 110    eu(n) = qs + (qc2*aq+qc1)*aq
        go to 130
 120    eu(n) = 0.
 130  continue
      if (ib.gt.nb) go to 340
      if (cabs(za).eq.0.) go to 150
      za = za/zbl(z1,c1(ib),c0(ib))
      if (ib.eq.nb) go to 150
      ma = ib + 1
      do 140 i=ma,nb
        za = za*zbl1(z1,b2(i),b1(i),b0(i))/zbl(z1,c1(i),c0(i))
 140  continue
 150  and = real(za)
c
 160  mark = 0
      r1 = 0.
      do 170 n=1,5
        if (eu(n).eq.0.) go to 170
        r1 = r1 + bn2(n)*bn0(n)*eu(n)
 170  continue
      r2 = 1.
      do 190 j=ib,nb
        if (j.ne.ib) r2 = r2*b2(j)*b0(j)
        q = c0(j)
        if (abs(q).gt.flmi) go to 180
        if (mark.ne.0) go to 360
        mark = j
        q = c1(j)
 180    r2 = r2/q
 190  continue
      if (mark.ne.0) go to 200
      pnu = pnu + r1*r2
      go to 280
c
 200  do 270 i=ib,nb
        if (i.eq.mark) go to 210
        q1 = c0(i)
        q2 = c1(i)
        go to 220
 210    q1 = c1(i)
        q2 = 1.
 220    if (i.ne.ib) go to 240
        r = 0.
        do 230 n=1,5
          if (eu(n).eq.0.) go to 230
          qq1 = bn2(n)*(bn1(n)*q1-bn0(n)*q2)/q1
          qq2 = bn0(n)*(bn1(n)-bn2(n)*c1(ib))
          r = r + (qq1+qq2)*eu(n)
 230    continue
        r = r*r2
        go to 260
 240    r = r1*(b2(i)*(b1(i)*q1-b0(i)*q2)/q1+b0(i)*(b1(i)-c1(i)*b2(i)))
        do 250 j=ib,nb
          if (j.ne.i .and. j.ne.ib) r = r*b2(j)*b0(j)
          q = c0(j)
          if (j.eq.mark) q = c1(j)
          r = r/q
 250    continue
 260    pnu = pnu + r
 270  continue
c
 280  do 330 j=ib,nb
        do 320 k=1,2
          zq = zp(j,k)
          if (cabs(zq).lt.flmi) go to 320
          kk = 3 - k
          zqi = zp(j,kk)
          zb = z1/(zq-zqi)
          zqi = z1/zq
          zb = zb*zqi
          za = z0
          do 290 n=1,5
            if (eu(n).eq.0.) go to 290
            za = za + eu(n)*zbl1(zq,bn2(n),bn1(n),bn0(n))*zbl1(zqi,
     *          bn2(n),bn1(n),bn0(n))
 290      continue
          zb = zb*za
          do 310 jj=ib,nb
            if (jj.eq.ib) go to 300
            zb = zb*zbl1(zq,b2(jj),b1(jj),b0(jj))*zbl1(zqi,b2(jj),b1(jj)
     *          ,b0(jj))
 300        if  (jj.ne.j) zb = zb/zbl(q,c1(jj),c0(jj))
            zb = zb/zbl(zqi,c1(jj),c0(jj))
 310      continue
          pnu = pnu + real(zb)
 320    continue
 330  continue
      return
c
 340  and = real(za)
      do 350 n=1,5
        pnu = pnu + eu(n)
 350  continue
      return
c
 360  call error(33)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   smax
c compute the maximum (ic=1) or minimum (ic=-1) of the transfer function
c-----------------------------------------------------------------------
c
      subroutine smax(bmax, mma, mme, ic)
c
      common /const/ pi, flma, flmi, fler
      common /cgrid/ gr(64), ngr(12)
c
      dimension o(5), b(5)
c
      flm = 1./flma
      fler1 = fler*0.05
      ma = ngr(mma)
      me = ngr(mme)
      bmax = 0.
      do 30 i=ma,me
        qr = amago(gr(i))
        if (ic.gt.0) go to 10
        if (qr.lt.flm) go to 220
        qr = 1./qr
  10    if (qr.lt.bmax) go to 20
        bmax1 = bmax
        max1 = max
        bmax = qr
        max = i
        go to 30
  20    if (qr.lt.bmax1) go to 30
        bmax1 = qr
        max1 = i
  30  continue
      jj = 1
      if ((me-ma).gt.1) go to 40
      o(1) = gr(ma)
      o(3) = (gr(ma)+gr(me))/2.
      o(5) = gr(me)
      jj = 3
      go to 60
  40  if (iabs(max-max1).lt.2) jj = 3
  50  if (max.eq.ma) max = ma + 1
      if (max.eq.me) max = max - 1
      o(1) = gr(max-1)
      o(3) = gr(max)
      o(5) = gr(max+1)
  60  do 80 i=1,5,2
        q = amago(o(i))
        if (ic.gt.0) go to 70
        if (q.lt.flm) go to 220
        q = 1./q
  70    b(i) = q
  80  continue
      go to 150
c
  90  emax = 0.
      do 100 i=1,5
        q = b(i)
        if (q.lt.emax) go to 100
        max = i
        emax = q
 100  continue
      if (emax.eq.bmax) go to 110
      if (emax/bmax-1..lt.fler) go to 180
 110  if (max.eq.3) go to 130
      if (max.lt.3) go to 120
      o(1) = o(3)
      b(1) = b(3)
      o(3) = o(4)
      b(3) = b(4)
      go to 140
 120  o(5) = o(3)
      b(5) = b(3)
      o(3) = o(2)
      b(3) = b(2)
      go to 140
 130  o(1) = o(2)
      b(1) = b(2)
      o(5) = o(4)
      b(5) = b(4)
 140  bmax = emax
 150  o(2) = (o(3)+o(1))/2.
      q = amago(o(2))
      if (ic.gt.0) go to 160
      if (q.lt.flm) go to 220
      q = 1./q
 160  b(2) = q
      o(4) = (o(3)+o(5))/2.
      q = amago(o(4))
      if (ic.gt.0) go to 170
      if (q.lt.flm) go to 220
      q = 1./q
 170  b(4) = q
      if (o(5)-o(1).ge.fler1) go to 90
 180  go to (190, 200, 210), jj
 190  emax = bmax
      bmax = bmax1
      bmax1 = emax
      max = max1
      jj = 2
      go to 50
 200  bmax = amax1(bmax,bmax1)
 210  if (ic.lt.0) bmax = 1./bmax
      return
 220  bmax = 0.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   smimp
c calculation of the sum of the impulse response magnitudes
c absolute scaling criterion
c-----------------------------------------------------------------------
c
      subroutine smimp(sum)
c
      common /const/ pi, flma, flmi, fler
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      dimension x1(16), x2(16)
      common /scrat/ adum(32)
      equivalence (adum(1),x1(1)), (adum(17),x2(1))
c
      do 10 i=1,nb
        x1(i) = 0.
        x2(i) = 0.
  10  continue
c
      bmax = 0.
      sum = 0.
      in = 0
      jn = 0
      y = fact
      im = 0
      go to 30
  20  y = 0.
  30  do 40 i=1,nb
        u = y
        y = u*b2(i) + x1(i)
        x1(i) = u*b1(i) - y*c1(i) + x2(i)
        x2(i) = u*b0(i) - y*c0(i)
  40  continue
      jm = sign(1.,y)
      y = abs(y)
      sum = sum + y
      bmax = amax1(bmax,y)
      if (im.ne.0) go to 50
      emax = bmax
      im = jm
      go to 20
  50  if (im.eq.jm) go to 70
      if (jn.gt.3) return
      in = 0
      q = emax/bmax
      emax = y
      im = jm
      if (q.lt.fler) go to 60
      jn = 0
      go to 20
  60  jn = jn + 1
      go to 20
  70  if (in.gt.3) return
      emax = amax1(emax,y)
      if (y/emax.lt.fler) in = in + 1
      go to 20
      end
c
c-----------------------------------------------------------------------
c function:     amago
c computation of the magnitude of the transfer function
c parameter omega in radians
c-----------------------------------------------------------------------
c
      function amago(omeg)
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
c
      complex c, ch
c
      c = cmplx(cos(omeg),sin(omeg))
      ch = cmplx(fact,0.)
c
      do 10 i=1,nb
        ch = ch*((b2(i)*c+b1(i))*c+b0(i))/((c+c1(i))*c+c0(i))
  10  continue
      amago = cabs(ch)
      return
      end
c
c-----------------------------------------------------------------------
c function:     phase
c phase of omega
c-----------------------------------------------------------------------
c
      function phase(om)
c
      complex cq, cf
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      cf = cmplx(fact,0.)
      cq = cmplx(cos(om),sin(om))
      do 10 i=1,nb
        cf = cf*((b2(i)*cq+b1(i))*cq+b0(i))/((cq+c1(i))*cq+c0(i))
  10  continue
      y = aimag(cf)
      x = real(cf)
      phase = atan2(y,x)
      return
      end
c
c-----------------------------------------------------------------------
c function:     resp
c response of an input signal
c-----------------------------------------------------------------------
c
      function resp(x, is)
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /cstatv/ x1(16), x2(16)
c
      if (is.eq.0) go to 20
c clear state variables
      do 10 i=1,nb
        x1(i) = 0.
        x2(i) = 0.
  10  continue
c
  20  y = x*fact
      do 30 i=1,nb
        u = y
        y = u*b2(i) + x1(i)
        x1(i) = u*b1(i) - y*c1(i) + x2(i)
        x2(i) = u*b0(i) - y*c0(i)
  30  continue
      resp = y
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   code3
c store pairing and ordering
c-----------------------------------------------------------------------
c
      subroutine code3(l, j, n)
c
      dimension j(16), l(16)
      do 10 i=1,n
        j(i) = l(i)
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   code4
c restore pairing and ordering
c-----------------------------------------------------------------------
c
      subroutine code4(l, j, n)
c
      dimension j(16), l(16)
      do 10 i=1,n
        l(i) = j(i)
  10  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   code5
c search for a given code array in ll
c restore pairing and ordering to l
c-----------------------------------------------------------------------
c
      subroutine code5(l, j, n, ll, m)
c
      dimension l(16), j(16), ll(16)
      m = 2
      do 30 i=1,n
        iq = j(i)
        do 10 ii=1,n
          if (iq.eq.ll(ii)) go to 20
  10    continue
        return
  20    l(i) = iq
  30  continue
      m = 1
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   quan
c check the actual coefficient quantization
c-----------------------------------------------------------------------
c
      subroutine quan(aco, acq)
c
      common /coptsp/ ib, jseqn(16), jseqd(16), amax, sca, alsbi
c
      q = abs(aco)
      if (q.ne.aint(q)) go to 10
      acq = 1.
      return
  10  q = q*alsbi
      acq = 0.5/alsbi
      go to 30
  20  q = q*0.5
      acq = acq*2.
  30  if (q.eq.aint(q)) go to 20
      return
      end
c
c-----------------------------------------------------------------------
c function:     acoef
c retransform one coefficient
c-----------------------------------------------------------------------
c
      function acoef(as, ie, id, ir)
c
      q = as*2.**(ir-ie)
      acoef = q
      if (id.le.(-100)) return
      ad = 2.**id
      acoef = q - sign(ad,as)
      return
      end
c
c-----------------------------------------------------------------------
c function:     acoefs
c transform one coefficient
c-----------------------------------------------------------------------
c
      function acoefs(ac, ie, id, ir)
c
      ad = 0.
      if (id.gt.(-100)) ad = 2.**id
      acoefs = (ac-sign(ad,ac))*2.**(ie-ir)
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   copy01
c copy coefficient field /filt/ into the field /sfilt/
c-----------------------------------------------------------------------
c
      subroutine copy01
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
c
      dimension aco(16,5), saco(16,5)
      equivalence (aco(1,1),b2(1)), (saco(1,1),sb2(1))
c
      nbs = nb
      sfact = fact
      do 20 j=1,5
        do 10 i=1,nb
          saco(i,j) = aco(i,j)
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   copy02
c copy coefficient field /sfilt/ into the field /filt/
c-----------------------------------------------------------------------
c
      subroutine copy02
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /sfilt/ nbs, sfact, sb2(16), sb1(16), sb0(16), sc1(16),
     *    sc0(16)
c
      dimension aco(16,5), saco(16,5)
      equivalence (aco(1,1),b2(1)), (saco(1,1),sb2(1))
c
      nb = nbs
      fact = sfact
      do 20 j=1,5
        do 10 i=1,nb
          aco(i,j) = saco(i,j)
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   copy03
c copy pole locations
c-----------------------------------------------------------------------
c
      subroutine copy03
c
      complex zp, zps
c
      common /filt/ nb, fact, b2(16), b1(16), b0(16), c1(16), c0(16)
      common /cpol/ zp(16,2), zps(16,2)
c
      do 20 i=1,nb
        do 10 j=1,2
          zp(i,j) = zps(i,j)
  10    continue
  20  continue
      return
      end
c
c-----------------------------------------------------------------------
c function:     dellk
c calculate complete elliptic integral of first kind
c-----------------------------------------------------------------------
c
      double precision function dellk(dk)
c
      double precision dpi, domi
      double precision de, dgeo, dk, dri, dari, dtest
c
      common /const/ pi, flma, flmi, fler
      common /const2/ dpi, domi
c
      data de /1.d00/
c
      dgeo = de - dk*dk
      if (dgeo) 10, 10, 20
  10  dellk = dble(flma)
      return
c
  20  dgeo = dsqrt(dgeo)
      dri = de
  30  dari = dri
      dtest = dari*domi
      dri = dgeo + dri
c
      if (dari-dgeo-dtest) 50, 50, 40
  40  dgeo = dsqrt(dari*dgeo)
      dri = 0.5d00*dri
      go to 30
  50  dellk = dpi/dri
      return
      end
c
c-----------------------------------------------------------------------
c function:     dsn2
c calculation of the jacobi's elliptic function sn(u,k)
c
c external calculation of the parameter necessary
c dk = k($k)
c dq = exp(-pi*k'/k) ... (jacobi's nome)
c-----------------------------------------------------------------------
c
      double precision function dsn2(du, dk, dq)
c
      double precision dpi, domi
      double precision de, dz, dpi2, dq, dm, du, dk, dc, dqq, dh, dq1,
     *    dq2
c
      common /const2/ dpi, domi
c
      data de, dz /1.d00,2.d00/
c
      dpi2 = dpi/dz
      if (dabs(dq).ge.de) go to 30
c
      dm = dpi2*du/dk
      dc = dz*dm
      dc = dcos(dc)
c
      dm = dsin(dm)*dk/dpi2
      dqq = dq*dq
      dq1 = dq
      dq2 = dqq
c
      do 10 i=1,100
        dh = (de-dq1)/(de-dq2)
        dh = dh*dh
        dh = dh*(de-dz*dq2*dc+dq2*dq2)
        dh = dh/(de-dz*dq1*dc+dq1*dq1)
        dm = dm*dh
c
        dh = dabs(de-dh)
        if (dh.lt.domi) go to 20
c
        dq1 = dq1*dqq
        dq2 = dq2*dqq
  10  continue
c
      go to 30
c
  20  dsn2 = dm
      return
c
  30  dsn2 = 0.d00
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   deli1
c elliptic function
c-----------------------------------------------------------------------
c
      subroutine deli1(res, x, ck)
c
      double precision res, x, ck, angle, geo, ari, pim, sqgeo, aari,
     *    test, dpi
      double precision domi
c
      common /const2/ dpi, domi
      if (x) 20, 10, 20
  10  res = 0.d0
      return
c
  20  if (ck) 40, 30, 40
  30  res = dlog(dabs(x)+dsqrt(1.d0+x*x))
      go to 130
c
  40  angle = dabs(1.d0/x)
      geo = dabs(ck)
      ari = 1.d0
      pim = 0.d0
  50  sqgeo = ari*geo
      aari = ari
      ari = geo + ari
      angle = -sqgeo/angle + angle
      sqgeo = dsqrt(sqgeo)
      if (angle) 70, 60, 70
c
c replace 0 by a small value
c
  60  angle = sqgeo*domi
  70  test = aari*domi*1.d+05
      if (dabs(aari-geo)-test) 100, 100, 80
  80  geo = sqgeo + sqgeo
      pim = pim + pim
      if (angle) 90, 50, 50
  90  pim = pim + dpi
      go to 50
 100  if (angle) 110, 120, 120
 110  pim = pim + dpi
 120  res = (datan(ari/angle)+pim)/ari
 130  if (x) 140, 150, 150
 140  res = -res
 150  return
      end
c
c-----------------------------------------------------------------------
c function:     sinh
c-----------------------------------------------------------------------
c
      function sinh(x)
c
      sinh = (exp(x)-exp(-x))/2.
      return
      end
c
c-----------------------------------------------------------------------
c function:     cosh
c-----------------------------------------------------------------------
c
      function cosh(x)
c
      cosh = (exp(x)+exp(-x))/2.
      return
      end
c
c-----------------------------------------------------------------------
c function:     arsinh
c-----------------------------------------------------------------------
c
      function arsinh(x)
c
      arsinh = alog(x+sqrt(x*x+1.))
      return
      end
c
c-----------------------------------------------------------------------
c function:     arcosh
c-----------------------------------------------------------------------
c
      function arcosh(x)
c
      if (x.lt.1.) go to 10
      arcosh = alog(x+sqrt(x*x-1.))
      return
  10  arcosh = 0.
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   dsqrtc
c computation of the complex square root in double precision
c     du + j*dv = sqrt ( dx + j*dy )
c-----------------------------------------------------------------------
c
      subroutine dsqrtc(dx, dy, du, dv)
c
      double precision dpi, domi
      double precision dx, du, dy, dv, dq, dp
      common /const2/ dpi, domi
c
      dq = dx
      dp = dy
c
      dv = 0.5d00*dq
      du = dq*dq + dp*dp
      du = dsqrt(du)
      du = 0.5d00*du
      dv = du - dv
      du = dv + dq
      if (dabs(du).le.3.d0*d1mach(3)) du = 0.d0
      du = dsqrt(du)
      if (dabs(dv).le.3.d0*d1mach(3)) dv = 0.d0
      dv = dsqrt(dv)
      if (dp.lt.(-domi)) du = -du
      return
      end
c
c-----------------------------------------------------------------------
c subroutine:   error
c output of an error message
c-------------------------------------------------------------------
c
      subroutine error(iercod)
c
      common /canpar/ ka1, ka2, ka3, ka4, ka5, line
c
      write (ka2,9999) iercod
9999  format (22h *** error *** number , i3)
      if (iercod.ge.20) stop
      return
      end
