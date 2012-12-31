$(document).ready(function() {
  // making contains case insensitive
  $.expr[":"].contains = $.expr.createPseudo(function(arg) {
        return function( elem ) {
           return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
  });

  $('#filteraction').click(function (){
    var txt = $('#filtertxt').val().trim();

    if(txt == ""){
      $('.categories a').removeClass('hidden');
    }else{
      $('.categories a').addClass('hidden');
      $(".categories a:contains(" + txt + ")").removeClass('hidden');
    }
  });
});
