var mediaParams, caller, callee;

QB.init(35038, 'yVQnaBUHBuHHr9B', '4TWZa9b4vRSeudf', CONFIG);

$(document).ready(function() {

  //buildUsers('.users-wrap.caller');


  // Choose recipient
  //
  $(document).on('click', '.choose-recipient button', function() {
    $('.choose-recipient button').removeClass('active');
    $(this).addClass('active');

    callee = {
      id: $(this).attr('id'),
      full_name: $(this).attr('data-name'),
      login: $(this).attr('data-login'),
      password: $(this).attr('data-password')
    };

    $('#calleeName').text(callee.full_name);
  });

  // Audio call
  //
  $('#audiocall').on('click', function() {
    if(callee == null){
      alert('Please choose a doctor to call');
      return;
    }

    var mediaParams = {
      audio: true,
      elemId: 'localVideo',
      options: { muted: true }
    };
    if (CurrentUsr == caller.id){
      $.ajax({
        type: 'post',
        url: '/create_history.js?qb_receiver_id='+callee.id + '&qb_caller_id='+ caller.id+'&chat_type=audio_call',
          success: function(data){
        },
          error: function(data){
        }
      });
    }
    callWithParams(mediaParams, true);
  });

  // Video call
  //
  $('#videocall').on('click', function() {
    if(callee == null){
      alert('Please choose a doctor to call');
      return;
    }

    var mediaParams = {
      audio: true,
      video: true,
      elemId: 'localVideo',
      options: {
        muted: true,
        mirror: true
      }
    };
    callWithParams(mediaParams, false);
    if (CurrentUsr == caller.id){
      $.ajax({
        type: 'post',
        url: '/create_history.js?qb_receiver_id='+callee.id + '&qb_caller_id='+ caller.id+'&chat_type=video_call',
          success: function(data){
        },
          error: function(data){
        }
      });
    }
    $('.streams').show();
  });

  // Accept call
  //
  $('#accept').on('click', function() {
    $('#incomingCall').modal('hide');
    $('#ringtoneSignal')[0].pause();

    QB.webrtc.getUserMedia(mediaParams, function(err, stream) {
      if (err) {
        console.log(err);
        var deviceNotFoundError = 'Devices are not found';
        updateInfoMessage(deviceNotFoundError);

        QB.webrtc.reject(callee.id, {'reason': deviceNotFoundError});
      } else {
        $('.btn_mediacall, #hangup').removeAttr('disabled');
        $('#audiocall, #videocall').attr('disabled', 'disabled');

        QB.webrtc.accept(callee.id);
        $.ajax({
        type: 'post',
        url: '/update_web_call_history.js?qb_receiver_id='+ caller.id + '&qb_caller_id='+ callee.id + '&call_status=received',
          success: function(data){
        },
          error: function(data){
        }
      });
      $('.streams').show();
      }
    });
  });


  // Reject
  //
  $('#reject').on('click', function() {
    $('#incomingCall').modal('hide');
    $('#ringtoneSignal')[0].pause();

    if (typeof callee != 'undefined'){
      QB.webrtc.reject(callee.id);
    }
    $('.streams').hide();
  });


  // Hangup
  //
  $('#hangup').on('click', function() {
    if (typeof callee != 'undefined'){
      QB.webrtc.stop(callee.id);
      $('.streams').hide();
      $.ajax({
        type: 'post',
        url: '/update_web_call_history.js?qb_receiver_id='+callee.id + '&qb_caller_id='+ caller.id + '&duration=1',
          success: function(data){
        },
          error: function(data){
        }
      });
      $('.streams').hide();
      if (CurrentUsrType == 'Patient'){
        window.location.href = '/patients/landing'
      }
      else{
        window.location.href = '/doctors/'+CurrentUsrId+'/history/'
      }
    }
  });


  // Mute camera
  //
  $('.btn_camera_off').on('click', function() {
    var action = $(this).data('action');
    if (action === 'mute') {
      $(this).addClass('off').data('action', 'unmute');
      QB.webrtc.mute('video');
    } else {
      $(this).removeClass('off').data('action', 'mute');
      QB.webrtc.unmute('video');
    }
  });


  // Mute microphone
  //
  $('.btn_mic_off').on('click', function() {
    var action = $(this).data('action');
    if (action === 'mute') {
      $(this).addClass('off').data('action', 'unmute');
      QB.webrtc.mute('audio');
    } else {
      $(this).removeClass('off').data('action', 'mute');
      QB.webrtc.unmute('audio');
    }
  });
});


//
// Callbacks
//

QB.webrtc.onSessionStateChangedListener = function(newState, userId) {
  console.log("onSessionStateChangedListener: " + newState + ", userId: " + userId);

  // possible values of 'newState':
  //
  // QB.webrtc.SessionState.UNDEFINED
  // QB.webrtc.SessionState.CONNECTING
  // QB.webrtc.SessionState.CONNECTED
  // QB.webrtc.SessionState.FAILED
  // QB.webrtc.SessionState.DISCONNECTED
  // QB.webrtc.SessionState.CLOSED

  if(newState === QB.webrtc.SessionState.DISCONNECTED){
    if (typeof callee != 'undefined'){
      QB.webrtc.stop(callee.id);
    }
    hungUp();
  }else if(newState === QB.webrtc.SessionState.CLOSED){
    hungUp();
  }
};

QB.webrtc.onCallListener = function(userId, extension) {
  console.log("onCallListener. userId: " + userId + ". Extension: " + JSON.stringify(extension));

  mediaParams = {
    audio: true,
    video: extension.callType === 'video' ? true : false,
    elemId: 'localVideo',
    options: {
      muted: true,
      mirror: true
    }
  };

  $('.incoming-callType').text(extension.callType === 'video' ? 'Video' : 'Audio');

  // save a callee
  callee = {
    id: extension.callerID,
    full_name: "User with id " + extension.callerID,
    login: "",
    password: ""
  };

  $('.caller').text(callee.full_name);

  $('#ringtoneSignal')[0].play();

  $('#incomingCall').modal({
    backdrop: 'static',
    keyboard: false
  });
};

QB.webrtc.onAcceptCallListener = function(userId, extension) {
  console.log("onAcceptCallListener. userId: " + userId + ". Extension: " + JSON.stringify(extension));

  $('#callingSignal')[0].pause();
  updateInfoMessage(callee.full_name + ' has accepted this call');
};

QB.webrtc.onRejectCallListener = function(userId, extension) {
  console.log("onRejectCallListener. userId: " + userId + ". Extension: " + JSON.stringify(extension));

  $('.btn_mediacall, #hangup').attr('disabled', 'disabled');
  $('#audiocall, #videocall').removeAttr('disabled');
  $('video').attr('src', '');
  $('#callingSignal')[0].pause();
  updateInfoMessage(callee.full_name + ' has rejected the call. Logged in as ' + caller.full_name);
};

QB.webrtc.onStopCallListener = function(userId, extension) {
  console.log("onStopCallListener. userId: " + userId + ". Extension: " + JSON.stringify(extension));

  hungUp();
  if (CurrentUsrType == 'Patient'){
    window.location.href = '/patients/landing'
  }
  else{
    window.location.href = '/doctors/'+CurrentUsrId+'/history/'
  }
};

QB.webrtc.onRemoteStreamListener = function(stream) {
  QB.webrtc.attachMediaStream('remoteVideo', stream);
};

QB.webrtc.onUserNotAnswerListener = function(userId) {
  console.log("onUserNotAnswerListener. userId: " + userId);
};


//
// Helpers
//

function callWithParams(mediaParams, isOnlyAudio){
  QB.webrtc.getUserMedia(mediaParams, function(err, stream) {
    if (err) {
      console.log(err);
      updateInfoMessage('Error: devices (camera or microphone) are not found');
    } else {
      $('.btn_mediacall, #hangup').removeAttr('disabled');
      $('#audiocall, #videocall').attr('disabled', 'disabled');
      updateInfoMessage('Calling...');
      $('#callingSignal')[0].play();
      //
      QB.webrtc.call(callee.id, isOnlyAudio ? 'audio' : 'video', {});
    }
  });
}

function hungUp(){
  // hide inciming popup if it's here
  $('#incomingCall').modal('hide');
  $('#ringtoneSignal')[0].pause();

  updateInfoMessage('Call is stopped. Logged in as ' + caller.full_name);

  $('.btn_mediacall, #hangup').attr('disabled', 'disabled');
  $('#audiocall, #videocall').removeAttr('disabled');
  $('video').attr('src', '');
  $('#callingSignal')[0].pause();
  $('#endCallSignal')[0].play();
}

function createSession() {
  QB.createSession(caller, function(err, res) {
    if (res) {
      connectChat();
    }
  });
}

function connectChat() {
  updateInfoMessage('Connecting to chat...');

  QB.chat.connect({
    jid: QB.chat.helpers.getUserJid(caller.id, QBApp.appId),
    password: caller.password
  }, function(err, res) {
    $('.connecting').addClass('hidden');
    $('.chat').removeClass('hidden');
    $('#callerName').text('You');

    updateInfoMessage('Logged in as ' + caller.full_name);
  })
}

function chooseRecipient(id) {
  $('.choose-user').addClass('hidden');
  $('.connecting').removeClass('hidden');
  updateInfoMessage('Creating a session...');
  buildRecipientUsers('.users-wrap.recipient', id);
  createSession();
}

function buildRecipientUsers(el, excludeID) {
  for (var i = 0, len = QBUsers.length; i < len; ++i) {
    var user = QBUsers[i];
    if (excludeID != user['id']) {
      var userBtn = $('<button>').attr({
        'class' : 'user',
        'id' : user['id'],
        'data-login' : user['login'],
        'data-password' : user['password'],
        'data-name' : user['full_name']
      });
      var imgWrap = $('<div>').addClass('icon-wrap').html( userIcon(user.colour) ).appendTo(userBtn);
      var userFullName = $('<div>').addClass('name').text(user.full_name).appendTo(userBtn);
      userBtn.appendTo(el);
    }
  }
}

function buildUsers(el, excludeID) {
  for (var i = 0, len = QBUsers.length; i < len; ++i) {
    var user = QBUsers[i];
    if (excludeID != user.id) {
      var userBtn = $('<button>').attr({
        'class' : 'user',
        'id' : user.id,
        'data-login' : user.login,
        'data-password' : user.password,
        'data-name' : user.full_name
      });
      var imgWrap = $('<div>').addClass('icon-wrap').html( userIcon(user.colour) ).appendTo(userBtn);
      var userFullName = $('<div>').addClass('name').text(user.full_name).appendTo(userBtn);
      userBtn.appendTo(el);
    }
  }
}

function updateInfoMessage(msg){
  $('#infoMessage').text(msg);
}

function userIcon(hexColorCode) {
  if (hexColorCode == 'Doctor'){
    return '<img src="/assets/doctor_img2.png">';
  }
  else{
   return '<img src="/assets/patient_img2.png">'; 
  }
}
