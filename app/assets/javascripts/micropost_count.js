$(document).ready(function(){
  function postCharCount(){
    var char, len, max;
    max = 140;
    len = $(this).val().length;
    char = max - len;
    $('.micropost-charsleft').text(char + " characters remaining");
  }
  $('.micropost-input').on({
    keyup: postCharCount,
    change: postCharCount
  });
});