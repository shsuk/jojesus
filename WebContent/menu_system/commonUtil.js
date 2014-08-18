	var oEditors = [];
	var option = {
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
		dayNamesMin: ["일","월","화","수","목","금","토"],
		showOn: "button",
		buttonImage: '../images/calendar.gif',
		buttonImageOnly: true,
		dateFormat: 'yy-mm-dd',
		changeYear: true,
		changeMonth: false

	};

	$(function() {
		$('.datepicker').datepicker(option);
		$('.spinner').spinner({ min: 1 });
		
		$.ajaxPrefilter(function( options, originalOptions, jqXHR ) {
			mask();
			if(options.url.indexOf('?')>0){
				options.url += '&_dumy=' + (new Date()).getTime();
			}else{
				options.url += '?_dumy=' + (new Date()).getTime();
			}
		});

		$( document ).ajaxComplete(function() {
			mask_off();
			$('.datepicker').datepicker(option);
			$('.spinner').spinner({ min: 1 });
		});
		//영문 숫자 입력 제한 처리
		$(document).on('keypress', '[key_press=alpa]', function(event){
			return alpa(event);
		});
		$(document).on('keypress', '[key_press=numeric]', function(event){
			return numeric(event);
		});
		$(document).on('keypress', '[key_press=alpa_numeric]', function(event){
			return alpa_numeric(event);
		});
		$(document).on('change', '[key_press]', function(event){
			var str = $(event.target).val();
			
			for (var i = 0; i < str.length; i++) {
				var code = str.charCodeAt(i);
				
				code = parseInt(code);

				if (code > 255 || code < 0){
					$(event.target).val('');
					alert('한글은 입력할 수 없습니다.');
					return;
				}
			}
		});
	});
	
	function getVal(name, obj) {
		if (obj) {
			var $row = $('.' + $(obj).attr('row_index'));
			return $('[name=' + name + ']', $row).attr('value');
		} else {
			return $('[name=' + name + ']').attr('value');
		}
	}
	function addObject(target, source){

		if(source) {
			$.each(source, function(key, value){
				target[key] = value;
			});
		}

		return target;
	}

	//tags/tag/check_array.tag 에서 호출
	function changeCheck(ctls, name){
		var vals = "";
		for(var i=0; i<ctls.length; i++){
			var val = $(ctls[i]).val();
			vals += "," + val;
		}

		vals = vals.substring(1);

		$('.check_hidden[name='+name+']').val(vals);
	}

	function checkValidOnChange(){
		$('[valid]').change(function(e){
			validItem(e.target);
		});
	}
	
	function valid(formId){
		var ctls = $('[valid]',$(formId));
		
		for(var i=0; i<ctls.length ; i++){
			
			if(!validItem(ctls[i])){
				return false;
			};
		}
		//if($('#subject').val().indexOf('<')>-1){
		//	alert("'<' 문자는 사용할수 없습니다.");
		//	$('#subject').focus();
		//	return false;
		//}
		return true;
	}	
	function validItem(obj){
		var ctl =$(obj);
		var valids = ctl.attr('valid').split(',');
		
		for(var n=0; n<valids.length; n++){
			var opt = valids[n].split(':');
			var fnc = opt[0].trim();
			
			var isValid = eval(fnc)(ctl, opt);
			if(!isValid){
				return false;
			}
		}
		return true;
	}
	function notempty(ctl){
		if(ctl.val().trim()=='' || ctl.val().trim()=='<br>'){
			alert($('[label='+ctl.attr('name')+']').text() + '에 값이 없습니다.');
			ctl.focus();
			return false;
		}
		return true;
	}
	function rangedate(ctl, opt){
		if($('#'+opt[1]).val() > $('#'+opt[2]).val()){
			alert($('[label='+ctl.attr('name')+']').text() + "의 시작일이 종료일보다 클 수 없습니다.");
			ctl.focus();
			return false;
		}
		return true;
	}
	function ext(ctl, opt){
		var val = ctl.val().toLowerCase();
		if(val=='') {
			return true;
		}
		for(var i=1; i<opt.length; i++){
			if(val.endsWith('.'+opt[i])){
				return true;
			}
		}
		
		alert($('[label='+ctl.attr('name')+']').text() + "에 첨부한 문서 종류는 등록 할 수 없습니다.");
		ctl.focus();
		return false;
		
	}
	
	
	
	//영문
	function alpa(event){
		if(event.charCode == 0 || (event.charCode >= 65 && event.charCode <= 90) || (event.charCode >= 97 && event.charCode <= 122)) {
			return true;
		}
		return false;	
	}

	//숫자
	function numeric(event){
		if(event.charCode == 0 ||  event.charCode >= 48 && event.charCode <= 57){ 
			return true;
		}
		return false;	
	}
	//영숫자
	function alpa_numeric(event){
		if(event.charCode == 0 ||  (event.charCode >= 48 && event.charCode <= 57) || (event.charCode >= 65 && event.charCode <= 90) || (event.charCode >= 97 && event.charCode <= 122)){ 
			return true;
		}
		return false;	
	}
	
	function mask(){
		//Get the screen height and width
		var maskHeight = $(window).height();
		var maskWidth = $(window).width();
		//Set height and width to mask to fill up the whole screen
		var mask = $('#mask');

		if(mask.length<1){
			$('body').append($('<div style="background: #cccccc; position:fixed;top: 0px;left: 0px;z-index: 9; text-align: center;padding-top: 200px;" id="mask"><span style="background: #ffffff;color:#0000ff;border:1px solid #ffffff;">처리중...</span></div>'));
			mask = $('#mask');
		}
		mask.css({'width':maskWidth,'height':maskHeight});
		
		//$('#mask').fadeIn(100);	//여기가 중요해요!!!1초동안 검은 화면이나오고
		$('#mask').fadeTo("slow",0.3);   //80%의 불투명도로 유지한다 입니다. ㅋ

	}
	function mask_off(){
		
		setInterval(function () {
			$('#mask').hide();
		}, 1000);		
	}