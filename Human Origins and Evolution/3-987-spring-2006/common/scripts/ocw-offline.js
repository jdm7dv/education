// MIT OpenCourseWare - Offline JS file

$(document).ready(function() {
    shuffled_sponsors_markup();
	setCopyrightText();
});


// Code Start for Shuffling sponsors Logos.

var sponsors_image_array = {
	img0 : [ 'http://ocw.mit.edu/images/logo_mathworks.png', 'Mathworks logo.', 'http://www.mathworks.com/'],
	img1 : [ 'http://ocw.mit.edu/images/logo_accenture.png', 'Accenture logo.', 'http://careers.accenture.com/'],
	img2 : [ 'http://ocw.mit.edu/images/logo_lockheed.png', 'Lockheed Martin logo.', 'http://www.lockheedmartin.com/'],
	img3 : [ 'http://ocw.mit.edu/images/logo_dow.png', 'Dow logo.', 'http://www.dow.com/'],
	img4 : [ 'http://ocw.mit.edu/images/logo_abinitio.png', 'Ab Initio logo.', 'http://www.abinitio.com/'],
    img5 : [ 'http://ocw.mit.edu/images/logo_telmex.png', 'Telmex logo.', 'http://www.academica.mx/']
	}
	
// This will return length of associative array
Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

//This function will shuffle the sponsors image array
function shuffle_sponsor_array(sponsors_image_array, len) {
	var shuffled_sponsors_array = sponsors_image_array;
 	var i = len;
	while (i--) {
	 	var random_position_no = parseInt(Math.random()*len);                                  //  This is 
		var current_sponsor = shuffled_sponsors_array['img'+i]                                 //  based on
		shuffled_sponsors_array['img'+i] = shuffled_sponsors_array['img'+random_position_no];  //  Fisher Yates algorithm
	  	shuffled_sponsors_array['img'+random_position_no] = current_sponsor;                   //  for shuffling
 	}
	return shuffled_sponsors_array;
}

// This will generate shuffled HTML markup for sponsors logos only for dspace site and for zips.
function shuffled_sponsors_markup()
{	
	var len = Object.size(sponsors_image_array);
	
	shuffled_sponsors_image_array = shuffle_sponsor_array(sponsors_image_array, len);
	
	shuffled_sponsors_html = '<h4 class="footer">Our Corporate Supporters</h4>';
	
	for (var i=0;i < len ;i++)
	{
		if (i%2 == 0) // Condition for checking whether logo will appear on left or right side and based on that inline styles will be applied.
		{
			if (shuffled_sponsors_image_array['img'+i][2] == '') // Checking whether logo has any anchor tag or not
			{
				shuffled_sponsors_html = shuffled_sponsors_html + '<img alt="'+ shuffled_sponsors_image_array['img'+i][1] + '" src="' + shuffled_sponsors_image_array['img'+i][0] + '" style="height: 53px; width: 145px; margin: 10px 10px 10px 0;" />';
			}
			else
			{
				shuffled_sponsors_html = shuffled_sponsors_html + '<a href="'+ shuffled_sponsors_image_array['img'+i][2] + '"><img alt="' + shuffled_sponsors_image_array['img'+i][1] + '" src="'+ shuffled_sponsors_image_array['img'+i][0] + '" style="height: 53px; width: 145px; margin: 10px 10px 10px 0;" /></a>';
			}
			
		}
		else
		{
			if (shuffled_sponsors_image_array['img'+i][2] == '')
			{
				shuffled_sponsors_html = shuffled_sponsors_html + '<img alt="'+ shuffled_sponsors_image_array['img'+i][1] + '" src="' + shuffled_sponsors_image_array['img'+i][0]  + '" style="height: 53px; width: 145px; margin: 10px 0;" /><br />';
			}
			else
			{
				shuffled_sponsors_html = shuffled_sponsors_html + '<a href="'+ shuffled_sponsors_image_array['img'+i][2] + '"><img alt="' + shuffled_sponsors_image_array['img'+i][1] + '" src="'+ shuffled_sponsors_image_array['img'+i][0] + '" style="height: 53px; width: 145px; margin: 10px 0;" /></a><br />';
			}
			
		}
	}
	$("#foot-c5").empty();
	$("#foot-c5").append(shuffled_sponsors_html);

}

// Code End for Shuffling sponsors Logos.


function clearSearchBox()
{
	if(document.getElementById("terms").value == "Search")
	{
		document.getElementById("terms").value = "";	
	}
}

function fillSearchBox()
{
	if(document.getElementById("terms").value == "")
	{
		document.getElementById("terms").value = "Search";	
	}
}

function clearEmailBox()
{
	if(document.getElementById("email").value == "Enter Email")
	{
		document.getElementById("email").value = "";	
	}	
} 

function fillEmailBox()
{
	if(document.getElementById("email").value == "")
	{
		document.getElementById("email").value = "Enter Email";	
	}
}

function OnTranslatedCoursesChange(url)
{
	if(url !="")
	{
		location = "http://ocw.mit.edu"+url;
	}
}

//Code to set the copyright text 
function setCopyrightText(){
$("p.copyright").html('');
present_date=new Date();
return $("p.copyright").append("&copy; 2001&ndash;"+ present_date.getFullYear() + "<br/> Massachusetts Institute of Technology");
}

//Code to set the 3Play transcript plug-in
function setThreePlayTranscriptPlugin(project_id, video_id){
	//return;     /* UNCOMMENT THIS IF YOU WANT TO DISABLE THE PLUGIN*/
	p3_external_stylesheet = window.location.host + "/styles/three_play.css";      
	window.p3_async_init = function(){
          P3.init({
            "embed_1" : {
              player_type: "jw",
              file_id: video_id, /* THIS SHOULD MATCH YOUR 3PLAY FILE ID */             
              api_version: "simple",
              project_id: project_id, /* THIS SHOULD MATCH YOUR 3PLAY PROJECT ID */
              transcript: {
                // OPTIONS
              can_collapse: true,
			  download_format: "pdf",
			  collapse_onload: true,
              target: "transcript1",
              skin: "cardinal_red",
              template: "default",
              progressive_tracking: true,
              width: 529,
              height: 208,
              can_print: true,
              search_placeholder:"Search this Video",
              hide_onerror:true,
			  can_clip: true,
			  search_transcript_stemming: true,
			  keyup_search: true,
              }
            }
          },"");    
        }
      }

// 16.90 Mo Index function to Toggle '+/-' on click event
function togglePlus(tableRowObj){ 
  
  var MOTag =$(tableRowObj).children().find("strong");
  var MOArray =$(MOTag).text().split(' ')
  
  MO = MOArray[1] + " " + MOArray[2] + " " + MOArray[3]
  if (MOArray[0]  == '+'){ $(MOTag).text('- '+MO) }
  else{ $(MOTag).text('+ '+MO) } 
};

// code for Edx converted courses

// Function for making new windows with specified html content
var windowRef = [];
window.newWindow = function(html,eqnstr) {
if ((windowRef[eqnstr] != undefined) &&(!windowRef[eqnstr].closed) ){ windowRef[eqnstr].close(); }
	windowRef[eqnstr] = window.open("",eqnstr,"height=100,width=400");
	if (windowRef[eqnstr]) {
        var d = windowRef[eqnstr].document;
        d.open();
        d.write(html);
        d.close();
    }

windowRef[eqnstr].focus();
}

// Add event listeners to allow edX onload functions to run in addition to our own (specified below)
if (window.addEventListener) { // Mozilla, Netscape, Firefox
    window.addEventListener('load', WindowLoad, false);
} else if (window.attachEvent) { // IE
    window.attachEvent('onload', WindowLoad);
}

// Our own onload function to listen for DOMSubtree modifications to call another javascript function that modifies the feedback "Correct" or "Incorrect" for the justification response section
function WindowLoad(event) {
    process_justifications();
    $("#seq_content").bind("DOMSubtreeModified", function() {
        process_justifications();
    });
}

function process_justifications() {
    var debugs = document.getElementsByClassName("debug");
    for (var i=0; i<debugs.length; i++) {
        if (debugs[i].innerHTML == "incorrect") {
             debugs[i].innerHTML = "provide justification";
        }
        if (debugs[i].innerHTML == "correct") {
            debugs[i].innerHTML = "justification submitted";
        }
    }
    // make something that sets Save buttons to hidden when "Sample Problems" is active in the menu
    if ($("li:contains('Sample Problems')").hasClass('active')) {
        var save_buttons = document.getElementsByClassName("save");
        for (var i=0; i<save_buttons.length; i++) {
            save_buttons[i].setAttribute('type','hidden');
        }
    }
}

//Functions for edx Assessments
//nostatus class ==> no tick no cross
//correct class ==> show tick
//wrong class ==> show cross
function numericTypedOrDropDownSelected(qid){//For numericalresponse and optionresponse problems
	var status_p = document.getElementById("Q"+qid+"_normal_status");
	var aria_status_p = document.getElementById("Q"+qid+"_aria_status");
	status_p.className="nostatus";
	aria_status_p.innerHTML="";
}

function optionSelected(qid){//for multiplechoiceresponse and choiceresponse problems
	var slides = document.getElementsByName("Q"+qid+"_input");
	for(var i = 0; i < slides.length; i++){		
		var status_p = document.getElementById(slides.item(i).id+"_normal_status");
		status_p.className="nostatus";
		var aria_status_p = document.getElementById(slides.item(i).id+"_aria_status");
		if(aria_status_p!=null){
		aria_status_p.innerHTML="";		
		}
		
	}
	//remove combined status_p of choiceresponse
	var status_p_combined=document.getElementById("Q"+qid+"_status_combined");
	if(status_p_combined!=null){
		status_p_combined.className="nostatus";
		status_p_combined.innerHTML="";	
	}	
 } 

function checkNumericalResponse(usr_input, ans, tolerance){//ans should be in range
	if((usr_input>=ans && usr_input<=(ans+tolerance)) || (usr_input<=ans && usr_input>=(ans-tolerance))){
		return true;
		}
	return false;	
}

function showHideSolution(prob_id_type_array, probem_btns_id, solution_div_array){	
	var button=document.getElementById("Q"+probem_btns_id+"_button_show");
	var sdiv=document.getElementById("S"+probem_btns_id+"_div");	
	var btnInnerHTML="Show Answer";
	var disp="none";
	var opResDisp="none";
	var statusClass="nostatus";
	var aria_text="";
		
	if (button.innerHTML=="Show Answer"){
		btnInnerHTML="Hide Answer";
		disp="block";
		statusClass="correct";
		opResDisp="inline";
		aria_text="[correct]";
	}
	
	button.innerHTML=btnInnerHTML;
	
	for (var qid in prob_id_type_array) {		
		type = prob_id_type_array[qid]		
		if (type=="optionresponse" || type=="stringresponse"){ 
			var ansp = document.getElementById("Q"+qid+"_ans_span");
			ansp.style.display=opResDisp;			
			ansp.focus();	
		}
	
		if(type=="numerical"){
			var ansp = document.getElementById("S"+qid+"_ans");
			ansp.innerHTML="Solution: "+document.getElementById("Q"+qid+"_ans").value;
			ansp.style.display=disp;			
			ansp.focus();
		}
		
		if(type=="choiceresponse" || type=="multiple_choice"){
			var checkboxes = document.getElementsByName("Q"+qid+"_input");
			for (var i=0; i<checkboxes.length; i++) {
					if( checkboxes[i].getAttribute('correct')=='true'){
						var status_p=document.getElementById(checkboxes[i].id+"_normal_status");
						status_p.className=statusClass;
						var aria_status_p=document.getElementById(checkboxes[i].id+"_aria_status");
						aria_status_p.innerHTML=aria_text;
					}											
			}				
	}
	
	if (solution_div_array.length > 0){
		for (var i = solution_div_array.length-1; i >= 0; i--) {
			sdiv = document.getElementById("S"+solution_div_array[i]+"_div")
			if(sdiv!=null && sdiv.innerHTML.trim()){
			sdiv.style.display=disp;
			sdiv.focus();
			}//if solution div is empty do not show it
		}
	}
	}
}

function checkAnswer(prob_id_type_array){
	var node;
	var status_p;
	var aria_status_p;
	var correct;
	var input_focus;
	for (var qid in prob_id_type_array) {
		correct=false;
		type = prob_id_type_array[qid];
		
		if(type=="numerical"){		
			input_focus=document.getElementById("Q"+qid+"_input");	
			var usr_input = parseFloat(input_focus.value);	
			var ans = parseFloat(document.getElementById("Q"+qid+"_ans").value);	
			var tolerance = document.getElementById("Q"+qid+"_tolerance").value;
			
			//handle tolerance
			if(tolerance.indexOf("%")>-1){//tolerance in %
				tolerance=parseFloat(tolerance)*(ans/100);
			}
			else{tolerance=parseFloat(tolerance);}	
					
			correct = checkNumericalResponse(usr_input, ans, tolerance);	
			status_p = document.getElementById("Q"+qid+"_normal_status");
			aria_status_p = document.getElementById("Q"+qid+"_aria_status");			
		}
		
		if (type=="stringresponse"){
			input_focus = document.getElementById("Q"+qid+"_input");
			status_p = document.getElementById("Q"+qid+"_normal_status");
			aria_status_p = document.getElementById("Q"+qid+"_aria_status");
			if(input_focus.getAttribute('ckecktype').indexOf("regexp") > -1){//regex case
			}
			else{ correct=(input_focus.value==input_focus.getAttribute('answer')); }			
		}
		
		if (type=="optionresponse"){
			input_focus = document.getElementById("Q"+qid+"_select");
			var option = input_focus.options[input_focus.selectedIndex];
			status_p = document.getElementById("Q"+qid+"_normal_status");
			aria_status_p = document.getElementById("Q"+qid+"_aria_status");
			if( option.getAttribute('correct')=='true' ){ correct=true; }
		}
		
		if(type=="multiple_choice"){
			var options = document.getElementsByName("Q"+qid+"_input");
			for (var i=0; i<options.length; i++) {
				if ( options[i].checked ) {				
					status_p=document.getElementById(options[i].id+"_normal_status");
					aria_status_p=document.getElementById(options[i].id+"_aria_status");
					input_focus=options[i];
					if( options[i].getAttribute('correct')=='true' ){ correct=true; }
					break;//as only one option checked in case of multiple_choice problem						
				}			
			}
		}
		
		if(type =="choiceresponse"){
			correct=true;
			status_p=document.getElementById("Q"+qid+"_status_combined");
			aria_status_p=status_p;//aria-status is also shown by status_p in this case
			input_focus=status_p;							//as of now the focus goes to status_p not any input
			var options = document.getElementsByName("Q"+qid+"_input");
			for (var i=0; i<options.length; i++) {
				if (( options[i].checked && options[i].getAttribute('correct')=='false') || (!options[i].checked && options[i].getAttribute('correct')=='true') ) {	     
					correct=false;
				}
			}		
		}//end choiceresponse
		
		//default is wrong
		if(status_p!=null){status_p.className="wrong";}	
		if(aria_status_p!=null){aria_status_p.innerHTML="[wrong]";}			
			if(correct){	
				if(status_p!=null){status_p.className="correct";}	
				if(aria_status_p!=null){aria_status_p.innerHTML="[correct]";}		
				}
		if(input_focus!=null){input_focus.focus();}				
	}
	return ;
}