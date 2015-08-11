// Based on Firebase's JS tutorial: https://www.firebase.com/tutorial

import 'dart:html';
import 'package:firebase/firebase.dart' as FB;

void main() {
  // create Firebase reference
  FB.Firebase fbRef = new FB.Firebase("https://l90j8hn4wau.firebaseio-demo.com");

  // get UI element references
  InputElement nameField = querySelector("#name-input");
  InputElement messageField = querySelector("#message-input");
  UListElement messageList = querySelector("#messages");

  // listen for ENTER key in message field
  messageField.onKeyPress.listen((KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER && messageField.value.isNotEmpty) {
      fbRef.push(value: {"name": nameField.value, "text": messageField.value});
      messageField.value = "";
    }
  });

  // listen for Firebase "childAdded" events
  fbRef.limitToLast(10).onChildAdded.listen((FB.Event event) {
    // get the message data
    Map data = event.snapshot.val();

    // check for anonymous post
    data['name'] = data['name'].isNotEmpty ? data['name'] : "Anonymous";

    // append message to UI
    messageList.appendHtml("<li><strong class='chat-username'>${data['name']}:</strong> ${data['text']}</li>");

    // scroll to bottom of message list
    messageList.scrollTop = messageList.scrollHeight;
  });
}
