



/********************************
Preloader
********************************/
$(window).load(function() {
  $('.loading-container').fadeOut(1000, function() {
	$(this).remove();
  });
});	






$(function(){

	
	/*$('.dropdown-menu').click(function(event){
	  event.stopPropagation();
	});*/
	
	
	
	
	/********************************
	Toggle Aside Menu
	********************************/
	
	$(document).on('click', '.menu_btn', function(){

    $('aside.left-panel').addClass('collapsed');
    $('.menu_btn').removeClass('menu_btn');
    $('.top-head').addClass('menu_test');
    $('body').css('cursor','pointer');
    });
            
    $(document).on('click', '.menu_test', function(){
        $('aside.left-panel').removeClass('collapsed');
        $('.navbar-toggle ').addClass('menu_btn');
        $('.menu_test ').removeClass('menu_test');
        $('body').css('cursor','default');
    });

    $(document).on('click','.warper',function(){
    if ($('aside.left-panel').hasClass('collapsed')){
        $('aside.left-panel').removeClass('collapsed');
        $('.navbar-toggle ').addClass('menu_btn');
        $('.menu_test ').removeClass('menu_test');
        $('body').css('cursor','default');
        }
    });

	
	
	
	/********************************
	Aside Navigation Menu
	********************************/

	$("aside.left-panel nav.navigation > ul > li:has(ul) > a").click(function(){
		
		if( $("aside.left-panel").hasClass('collapsed') == false || $(window).width() < 768 ){

		
		
		$("aside.left-panel nav.navigation > ul > li > ul").slideUp(300);
		$("aside.left-panel nav.navigation > ul > li").removeClass('active');
		
		if(!$(this).next().is(":visible"))
		{
			
			$(this).next().slideToggle(300,function(){ $("aside.left-panel:not(.collapsed)").getNiceScroll().resize(); });
			$(this).closest('li').addClass('active');
		}
		
		return false;
		
		}
		
	});
	
	
	
	/********************************
	popover
	********************************/
	if( $.isFunction($.fn.popover) ){
	$('.popover-btn').popover();
	}
	
	
	
	/********************************
	tooltip
	********************************/
	if( $.isFunction($.fn.tooltip) ){
	$('.tooltip-btn').tooltip()
	}
	
	
	
	/********************************
	NanoScroll - fancy scroll bar
	********************************/
	if( $.isFunction($.fn.niceScroll) ){
	$(".nicescroll").niceScroll({
	
		cursorcolor: '#9d9ea5',
		cursorborderradius : '0px'		
		
	});
	}
	

	if( $.isFunction($.fn.niceScroll) ){
	$("aside.left-panel:not(.collapsed)").niceScroll({
		cursorcolor: '#8e909a',
		cursorborder: '0px solid #fff',
		cursoropacitymax: '0.5',
		cursorborderradius : '0px'	
	});
	}

	
	
	
	
	/********************************
	Input Mask
	********************************/
	if( $.isFunction($.fn.inputmask) ){
		$(".inputmask").inputmask();
	}
	
	
	
	
	
	/********************************
	TagsInput
	********************************/
	if( $.isFunction($.fn.tagsinput) ){
		$('.tagsinput').tagsinput();
	}
	
	
	
	
	
	/********************************
	Chosen Select
	********************************/
	if( $.isFunction($.fn.chosen) ){
		$('.chosen-select').chosen();
        $('.chosen-select-deselect').chosen({ allow_single_deselect: true });
	}
	
	
	
	
	/********************************
	DateTime Picker
	********************************/
	if( $.isFunction($.fn.datetimepicker) ){
		$('#datetimepicker').datetimepicker();
		$('#datepicker').datetimepicker({pickTime: false});
		$('#timepicker').datetimepicker({pickDate: false});
		
		$('#datetimerangepicker1').datetimepicker();
		$('#datetimerangepicker2').datetimepicker();
		$("#datetimerangepicker1").on("dp.change",function (e) {
		   $('#datetimerangepicker2').data("DateTimePicker").setMinDate(e.date);
		});
		$("#datetimerangepicker2").on("dp.change",function (e) {
		   $('#datetimerangepicker1').data("DateTimePicker").setMaxDate(e.date);
		});
	}
	
	
	/********************************
	wysihtml5
	********************************/
	if( $.isFunction($.fn.wysihtml5) ){
		$('.wysihtml').wysihtml5();
	}
	
	
	
	/********************************
	wysihtml5
	********************************/
	if( $.isFunction($.fn.ckeditor) ){
	CKEDITOR.disableAutoInline = true;
	$('#ckeditor').ckeditor();
	$('.inlineckeditor').ckeditor();
	}
	
	
	
	
	
	
	
	
	
	/********************************
	Scroll To Top
	********************************/
	$('.scrollToTop').click(function(){
		$('html, body').animate({scrollTop : 0},800);
		return false;
	});
	
	
	

});








/********************************
Toggle Full Screen
********************************/

function toggleFullScreen() {
	if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
		if (document.documentElement.requestFullScreen) {
			document.documentElement.requestFullScreen();
		} else if (document.documentElement.mozRequestFullScreen) {
			document.documentElement.mozRequestFullScreen();
		} else if (document.documentElement.webkitRequestFullScreen) {
			document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
		}
	} else {
		if (document.cancelFullScreen) {
			document.cancelFullScreen();
		} else if (document.mozCancelFullScreen) {
			document.mozCancelFullScreen();
		} else if (document.webkitCancelFullScreen) {
			document.webkitCancelFullScreen();
		}
	}
}




/********************************
CUSTOM SCRIPT
********************************/

$(document).ready(function(){
  $('.newsbloghead').click(function(){
     var a = $(this).attr('for');
     $('.newsblogdiv').hide();
     $('.'+a).show();
     $('.'+a).removeClass('othrnewsblogdiv');
   });

   $('.NextBtn').click(function(){
     var a = $(this).attr('for');
     var a1 = $(this).attr('data-for');
     $('.'+a1).hide();
     $('.'+a1).find('.newsblogdiv').hide();
     $('.'+a).show();
     $('.'+a).find('.newsblogdiv').first().show();
   });

   $('.PreBtn').click(function(){
     var a = $(this).attr('for');
     var a1 = $(this).attr('data-for');
     $('.'+a1).hide();
     $('.'+a1).find('.newsblogdiv').hide();
     $('.'+a).show();
     $('.'+a).find('.newsblogdiv').first().show();
   });


    $('#example1,#example2').datepicker({
      format: "dd/mm/yyyy"
    });
	$('#example1,#example2').keydown(function(e) {
	  e.preventDefault();
	  return false;
	});  

	$('.user_image_show_button').hide();
	$('.user_image_edit_button').click(function(){
		$('.slectImageCheck').toggle();
		$('.user_image_show_button').toggle();
	});

	var targetRow = $('.listData_table td:nth-of-type(1) a');
	$(targetRow).click(function(){
		var targetDate = $(this).children('.date').text().trim();
		var targetAddress = $(this).children('.Ename').text().trim();
		var targetdname = $(this).children('.dname').text().trim();
		var targetid = $(this).children('.obj_id').text().trim();
		var msg = targetDate + targetAddress + targetdname + targetid;
		$('.sdateinput').val(targetDate);
		$('.snameinput').val(targetAddress);
		$('.dnameinput').val(targetdname);
		$('.obj_idinput').val(targetid);
		$('.dateerror').html('');
		$('.dispnameerror').html('');
		$('.nameerror').html('');
		});
		
	var targetRow = $('.parking_lot td:nth-of-type(2) a');
	$(targetRow).click(function(){
		var targetDate = $(this).children('.date').text().trim();
		var targetAddress = $(this).children('.Ename').text().trim();
		var targetdname = $(this).children('.dname').text().trim();
		var targetid = $(this).children('.obj_id').text().trim();
		var msg = targetDate + targetAddress + targetdname + targetid;
		$('.sdateinput').val(targetDate);
		$('.snameinput').val(targetAddress);
		$('.dnameinput').val(targetdname);
		$('.obj_idinput').val(targetid);
		$('.dateerror').html('');
		$('.dispnameerror').html('');
		$('.nameerror').html('');
		});	
		
		
		$('.add_challenge').click(function(){
		  var targetdname=$(this).parent().parent().children('.eDitPictur').children('.desc').html().trim();
		  var targetid = $(this).attr('for').trim();
		  $('.ch_nameinput').val(targetdname);
		  $('.ch_d_nameinput').val(targetdname);
		  $('.sugesn_idinput').val(targetid);
		  $('.dateerror').html('');
		  $('.dispnameerror').html('');
		  $('.nameerror').html('');
		})
		
		
		$('.addChallengeOnDate').click(function(){
		  var targetDate = $(this).children('.date').text().trim();
		  $('.addchallengedateinput').val(targetDate);
		  $('.field_with_errors .message').html('');
		})


		/*$('.aHeaderMenuLink').click(function(){
		  var targetDate = $('.popup-container,.popup-info').css('display')
		  if(targetDate =="none")
		  $('.popup-container,.popup-info').slideDown(500)
		  else{
		  $('.popup-container,.popup-info').slideUp(500)
		  }
		})*/
		
});




jQuery.fn.anchorAnimate = function(settings) {
        settings = jQuery.extend({
                        speed : 1100
        }, settings);
    return this.each(function(){
        var caller = this
        $(caller).click(function (event) {
                event.preventDefault()
                var locationHref = window.location.href
                var elementClick = $(caller).attr("href")

                var destination = $(elementClick).offset().top;
                $("html:not(:animated),body:not(:animated)").animate({ scrollTop: destination}, settings.speed, function() {
                                window.location.hash = elementClick
                });
                return false;
        })
    })
}
$("a.slide").anchorAnimate();


