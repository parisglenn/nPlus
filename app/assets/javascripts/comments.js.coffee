# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# Type here!
jQuery ->
      $("#comment_submit_btn")
        .on "click", (e) ->
          if $("#comment_body").val() is ""
            e.preventDefault();
            if $("#comment_body").hasClass('invalid-input')
              false
            else
              $("#comment_body").addClass('invalid-input')
              .parent()
              .append("<p class='message'>This field is required</p>");
              false
          else
            $("#comment_body")
            .removeClass('invalid-input')
            .parent()
            .parent()
            .parent()
            .find('p')
            .remove()            
      # Create a comment
      $(".comment-form")
        .on "ajax:beforeSend", (evt, xhr, settings) ->
          $(this).find('textarea')
            .addClass('uneditable-input')
            .attr('disabled', 'disabled');
        .on "ajax:success", (evt, data, status, xhr) ->
          $(this).find('textarea')
            .removeClass('uneditable-input')
            .removeAttr('disabled', 'disabled')
            .val('');
          $(xhr.responseText).hide().insertAfter($(this)).show('slow')

      $(document)
        .on "ajax:beforeSend", ".comment", ->
          $(this).fadeTo('fast', 0.5)
        .on "ajax:success", ".comment", ->
          $(this).hide('fast')
        .on "ajax:error", ".comment", ->
          $(this).fadeTo('fast', 1)