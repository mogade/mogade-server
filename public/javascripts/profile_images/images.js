var $document = $(document).ready(function()
{
  var $images = $('.uploadedImage');
  var $uploadButtons = $('div.uploadButton');
  var $deleteButtons = $('div.deleteButton');
  var options = 
  {
    action: '/manage/facebook/upload',
    params: {authenticity_token: AUTH_TOKEN, game_id: game_id},
    multiple: false,
    sizeLimit: max_image_length,
    allowedExtensions: ['gif', 'png', 'jpeg', 'jpg'],
    onComplete: function(id, name, r) 
    { 
      $images[r.index].src = profile_image_root + r.name; 
      $uploadButtons.eq(r.index).removeClass('uploading');
      $deleteButtons.eq(r.index).show();
    }
  };
  for(var i = 0; i < 7; ++i)
  {
    var o = jQuery.extend(true, {}, options);
    o['button'] = $uploadButtons[i];
    o['params']['index'] = i;
    new qq.FileUploaderBasic(o);
  }
  $document.confirm('div.deleteButton', 'Delete this image?', 'This will remove the image from your profile, are you sure?', function($div)
  { 
    return do_delete('/manage/facebook/' + game_id + '?index=' + $div.data('i'), null, function(r)
    {
      $images[r.index].src = '/images/trans.gif';
      $deleteButtons.eq(r.index).hide();
    }); 
  });
});