$(function(){
  $('.cmsInnerTable').parent('td').addClass('padLR')
  $('div.pagination,div.digg_pagination').append('<div class="clear"></div>')
  $('.formLayout .row,.productDtls .row').each(function(i){
    $(this).append('<div class="clear"></div>')
  })
  $(window).bind('scroll', function() {
	  if ($(window).scrollTop() > 80) {
	  $('.mainNav').addClass('fixedTop');
	  }
	  else {
	  $('.mainNav').removeClass('fixedTop');
	  }
  });
})

$(function(){
  $('.fieldInfo a').click(function(){
    $('body').append('<div class="overlay"></div>')
    $('.overlayBox').append('<div class="closeBtn">X</div>')
    $('.overlay').fadeIn();
    var popUpId = $(this).next('.overlayBox');
    var winWidth = $(window).width();
    var winHeight = $(window).height();
    var boxHeight = $(popUpId).outerHeight();
    var boxWidth = $(popUpId).outerWidth();
    var marginTB = (winHeight-boxHeight)/ 2;
    var marginLR = (winWidth-boxWidth)/2;
    if(marginTB<0)
    {
	    $(popUpId).css('top','0');
	    $(popUpId).css('left',+ marginLR);
	    $(popUpId).fadeIn();
    }
    else
    {
    $(popUpId).css('top',+ marginTB);
    $(popUpId).css('left',+ marginLR);
    $(popUpId).fadeIn();
    }
  });
  $('.closeBtn').bind('click', function(){
    $('.overlayBox').fadeOut();
    $('.overlay').fadeOut(); 
  })
})

$(function(){
a = $('#thumb').find('.current')
a.closest('.hoverMenu').show();
a.closest('.hoverMenu').prev('a').addClass('admindrop');




$('.newAdmindrop').click(function(){
  $('#thumb').find('.admindrop').removeClass('admindrop');
  $('#thumb').find('.newAdmindrop').each(function(e){
    $(this).children('a').css('background','url(/assets/showadminarow.png) 90% 14px no-repeat #3D3D3D');
  });
   var horvMenu=$(this).children('.hoverMenu').css('display');
   $('.hoverMenu').slideUp();
   if(horvMenu=='none')
   {
    $(this).children('.hoverMenu').slideDown();
    $(this).children('a').css('background','url(/assets/downadminarow.png) 90% 14px no-repeat #D64635');
    $(this).children('a').addClass('admindrop')
   }
   else
   {
    $(this).children('.hoverMenu').slideUp();
    $(this).children('a').css('background','url(/assets/showadminarow.png) 90% 14px no-repeat #3D3D3D');
   }
  
  })

})

function update_attribute(url, status, current) {
  $.ajax({
  url: url + status,
    success: function() {
      $(current).val(status);
      alert("successfull")
    }
  });
}
