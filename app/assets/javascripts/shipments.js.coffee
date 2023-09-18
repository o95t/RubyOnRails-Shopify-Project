# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

	payment_type = $("#shipment_payment_type").val()
	$("#shipment_payment_type").change ->
	  alert "Oops! You can't change payment type"
	  $("#shipment_payment_type").val payment_type
	  false

	$('#shipment_payment_type').change ->
		if $('#shipment_payment_type').val() is "P"
			# "Show options for Prepaid"
			$("#shipment_payment_options").html "<option value=\"\"></option><option value=\"CASH\" selected=\"selected\">Cash</option><option value=\"ACCT\">Account</option><option value=\"CRDT\">Credit</option>"
		else
			# "Show options for Collect"
			$("#shipment_payment_options").html "<option value=\"\"></option><option value=\"ARCC\">ARCC</option></select>"

	$('#show_attachments_div_btn').click (event) ->
		event.preventDefault()
		$('#attachments_div').css('display', 'block')
		$('#show_attachments_div_btn').css('display', 'none')

	$('#add_another_attachment_btn').click (event) ->
		event.preventDefault()
		attachments_count = $('#attachments_div').data('attachments-count')
		if attachments_count < 10
			attachments_count = attachments_count + 1
			$("<div class=\"control-group file optional\"><label class=\"file optional control-label\" for=\"shipment_attachment" + (attachments_count) + "\">Attachment " + (attachments_count) + "</label><div class=\"controls\"><input class=\"file optional\" id=\"shipment_attachment" + (attachments_count) + "\" name=\"shipment[attachment" + (attachments_count) + "]\" type=\"file\"></div></div>").insertBefore "#add_another_attachment_btn"

			$('#attachments_div').data('attachments-count', attachments_count)

			if attachments_count == 10
				$("#add_another_attachment_btn").css('display', 'none')

	# Call the selectpicker bootstrap-select library
########################$('.selectpicker').selectpicker()

	# Initialize whereever we are using Bootstrap tooltips
	$('.has-tooltip').tooltip()

  

	        $(".add-attachments").click(function () {
             $(this).hide();
             $(".add-attachments-over").fadeIn('fast');
             $(".add-attachments-small").fadeIn('fast');
             
        });
                   
        $(".custom-file-close").click(function () {
            removeFiles($(this))
        });


$('#validatedCustomFile').on('change', function(){
addLinkToDownload($(this))
            })

        $(".add-anoter-attachments").click(function () {
            increaseFiles();
        });

       function addLinkToDownload(value) {
                var fileName = value.val();
                value.next('.custom-file-label').html(fileName);
        }

        function increaseFiles() {
            var filefieldToClone = $(".add-attachments-over .custom-file").eq(0).clone();
            
            var totalFilestoClone = $(".custom-file");
            if(totalFilestoClone.length > 4){
                return false;
            }
            var i = totalFilestoClone.length;
                 filefieldToClone.find('input').each(function () {
                    this.name = this.name.replace('[0]', '[' + i + ']');
                    $(this).next().text("");
                     $(this).on('change', function(){
                    addLinkToDownload($(this))
            })
                });
                $('.add-attachments-over').append(filefieldToClone);
                $(".custom-file-close").click(function () {
                        removeFiles($(this))
                });

        }

        function removeFiles(value) {
            var totalFilestoClone = $(".custom-file");
            if(totalFilestoClone.length < 2){
                return false;
            }
            value.closest('.custom-file').remove();
             addNameValues();
        }

        function addNameValues() {
            var totalFilestoClone = $(".custom-file");
            var max = totalFilestoClone.length;
            var filefieldToClone = $(".add-attachments-over .custom-file");

var i=0;
                 filefieldToClone.find('input').each(function () {
                    $(this).attr('name', 'shipments[' + i + ']');
                    i++;
                });

        }


        function makeValidation() {
        var buttonsClick = [
        ["packageWeight","Weight"],
        ["packageLength", "Length"], 
        ["packageWidth","Width"], 
        ["packageHeight","Height"]
        ];

        /* Make All Buttons Active once click on buttons */
        for (var s in buttonsClick) {
            var id = buttonsClick[s][0];
            var text = buttonsClick[s][1];
            (function (class_text, text) {
                $('.' + class_text).on("blur", function (e) {
                    emptySpecial3Validation($(this), text);
                });
            }(id,text))
        }

        }
		makeValidation();

        function emptySpecial3Validation(value, label) {
            var field = value.val();
            if (field.trim().length == 0) {
                value.parent().next('div.red').remove();
                value.parent().after("<div class=\'red\'> Required</div>");
                errors.push(value.attr('id') + "_required");
            } else {
                value.parent().next('div.red').remove();
                errors = removeError(errors, value.attr('id') + "_required");
            }
            makeAllButtonsActive(value);
        }

        var $input = $("#totalPackagesWeight").val(1);
        $(".altera").click(function () {
            if ($(this).hasClass('acrescimo')) {
                var newValue = parseInt($input.val()) + 1;
                $input.val(newValue);
                increaseLines();
            } else if ($input.val() >= 2) {
            	var newValue = parseInt($input.val()) - 1;
                $input.val(newValue);
                decreaseLines();
            }
        });


        function increaseLines() {
            var packagestoClone = $(".weight-line-clone").eq(0).clone();
            var totalPackagestoClone = $(".weight-line-clone");
            var i = totalPackagestoClone.length;
                 packagestoClone.find('input').each(function () {
                    this.name = this.name.replace('[0]', '[' + i + ']');
                });
                $('.weight-line-clone-over').append(packagestoClone);
                makeValidation();
        }

        function decreaseLines() {
            var lastClone = $(".weight-line-clone:last-child").remove();
        }


        $('#metric').click(function () {
        	var packages = $(".weight-line-clone");
            $(this).addClass('grey-button-border');
            $('#imperial').removeClass('grey-button-border');
            packages.find('p').each(function () {
                if ($(this).attr('class') !== "p-weight") {
                    $(this).text("CM");
                } else {
                    $(this).text("KG");
                }
            });

        });

        $('#imperial').click(function () {
        	var packages = $(".weight-line-clone");
            $(this).addClass('grey-button-border');
            $('#metric').removeClass('grey-button-border');
            packages.find('p').each(function () {
                if ($(this).attr('class') !== "p-weight") {
                    $(this).text("IN");
                } else {
                    $(this).text("lbs");
                }
            });
        });

        /* Open first tab with cleaning of values */
        $('.switcher').click(function () {
            if ($(this).hasClass('active')) {
                $(this).removeClass('active');
                $('.shipper .create-shipping-block-top').addClass('active');
                $('.shipper .create-shipping-block-body').fadeIn("slow");
                $('.shipper .create-shipping-block-body').find(':input').not(':button, :submit, :reset, :hidden, :checkbox, :radio').val('');
            } else {
                $(this).addClass('active');
                $('.shipper .create-shipping-block-top').removeClass('active');
                $('.shipper .create-shipping-block-body').hide();

            }
        });
        /* Clicking on button Next */
        $('.button-next').click(function () {
            if ($("#orderNumber").val().trim() === "") {
                $("html, body").animate({scrollTop: 0}, "slow");
            }
            makeAllButtonsActive($(this));
            if (!$(this).hasClass('passive')) {
                $(this).parent().parent().find('.create-shipping-block-top').removeClass('active');
                $(this).parent().hide();
                $(this).parent().parent().find('.create-shipping-block-top').find('.triangle').removeClass('active');
                $(this).parent().parent().next().find('.create-shipping-block-body').fadeIn("slow");
                $(this).parent().parent().next().find('.create-shipping-block-top').addClass('active');
                $(this).parent().parent().next().find('.create-shipping-block-top').find('.triangle').addClass('active');
                $(this).parent().parent().next().find('.create-shipping-block-body').find("#goodsDescription").focus();
                $(this).parent().parent().next().find('.create-shipping-block-body').find("#totalPackagesWeight").focus();
            }
        });


        /* Buttons actions*/
        if ($('#productGroup').hasClass('grey-button-border')) {
            $('.international').hide();
            $('.domestic').fadeIn("slow");
        }
        if ($('#productType').hasClass('grey-button-border')) {
            $('.domestic').hide();
            $('.international').fadeIn("slow");
        }

        if ($('#cashOnDelivery').hasClass('grey-button-border') ) {
            $('.block-cod').fadeIn("slow");
        }
        if ($('#prepaid').hasClass('grey-button-border')) {
            $('.block-cod').hide();
        }

        $('#productGroup').click(function () {
            $(this).addClass('grey-button-border');
            $('#productType').removeClass('grey-button-border');
            $('.international').hide();
            $('.domestic').fadeIn("slow")
        });

        $('#productType').click(function () {
            $(this).addClass('grey-button-border');
            $('#productGroup').removeClass('grey-button-border');
            $('.domestic').hide();
            $('.international').fadeIn("slow");
                    if ($('#cashOnDelivery_int').hasClass('grey-button-border') ) {
            $('.block-cod').fadeIn("slow");
        }
        if ($('#prepaid_int').hasClass('grey-button-border')) {
            $('.block-cod').hide();
        }
        });

        $('#cashOnDelivery').click(function () {
            $('.block-cod').fadeIn("slow");
        });

        $('#prepaid').click(function () {
            $('.block-cod').hide("slow");
        });
        $('#cashOnDelivery_int').click(function () {
            $('.block-cod').fadeIn("slow");
        });
        
        $('#prepaid_int').click(function () {
            $('.block-cod').hide("slow");
        });

        $('.grey-button').click(function () {
            $(this).closest('.aramex-input-block2').find(".grey-button").removeClass('grey-button-border')
            $(this).addClass('grey-button-border')
        });

        /* Shipper validation */

        $("#orderNumber").focus();
    

        var errors = [];

        $("#orderNumber").blur(function () {
            emptyValidation($(this), 'Order Number');
        });

        $("#shipperName").blur(function () {
            emptyValidation($(this), 'Shipper Name');
        });
        $("#companyName").blur(function () {
            emptyValidation($(this), 'Company Name');
        });

        $("#emailAddress").blur(function () {
            emptyValidation($(this), 'Email Address');
            emailValidation($(this), 'Email Address');
        });

        $("#addressLine1").blur(function () {
            emptyValidation($(this), 'Address line 1');
        });

        $("#State").blur(function () {
            emptyValidation($(this), 'State');
        });

        $("#originCode").blur(function () {
            emptyValidation($(this), 'Zip Code');
        });

        $("#originCity").blur(function () {
            emptyValidation($(this), 'City');
        });
        $("#originPhone").blur(function () {
            emptySpecialValidation($(this), 'Phone number');
        });

        $("#originMobile").blur(function () {
            emptySpecialValidation($(this), 'Mobile Number');
        });


        $("#reciverPhone").blur(function () {
            emptySpecialValidation($(this), 'Phone number');
        });

        $("#reciverMobile").blur(function () {
            emptySpecialValidation($(this), 'Mobile Number');
        });


var filesExt = ['exe']; // validate .exe files

$('input[type=file]').change(function(){
    var parts = $(this).val().split('.');
    if(filesExt.join().search(parts[parts.length - 1]) != -1){
    	$(this).val("");
    	$(this).next().text("");
        alert('.exe files are not allowed to download!');
        return false;
    } 
})


        var emptyValidationFields = 
        [
        ["reciverCity","City"],
        ["reciverCode", 'Zip Code'],
        ["reciverState", 'State'],   
        ["addressReciverLine1", 'Address line 1'],
        ["emailReciverAddress", 'Email Address'],  
        ["companyReciverName", 'Company Name'],
        ["receiverName", 'Receiver Name'],
        ];

        /* Make All Buttons Active once click on buttons */
        for (var s in emptyValidationFields) {
            var id = emptyValidationFields[s][0];
            var text = emptyValidationFields[s][1];
            (function (id_text, text) {
                $('#' + id_text).on("blur", function (e) {
                    emptyValidation($(this), text);
                });
            }(id,text))
        }

        /* Reciver validation */
        $("#emailReciverAddress").blur(function () {
          // emptyValidation($(this), 'Email Address');
            emailValidation($(this), 'Email Address');
        });

        /* Shipment Details validation */
        $("#goodsDescription").blur(function () {
            emptyValidation($(this), 'Goods Description');
        });

        $("#weight").blur(function () {
            emptySpecialValidation($(this), 'Weight');
        });

        $("#declaredValue").blur(function () {
            emptySpecialValidation($(this), 'Declared value');
        });

        $("#cod").blur(function () {
            emptySpecialValidation($(this), 'Cash on Delivery');
        });

        $("#numberPieces").blur(function () {
            emptyValidation($(this), 'Number of pieces');
        });


        /* Chargeable weight validation */

        $("#totalPackagesWeight").blur(function () {
            emptytotalPackageValidation($(this), 'Total Packages');
        });
        
        $("#package").blur(function () {
            emptyValidation($(this), 'Package');
        });


        function emptyValidation(value, label) {
            var field = value.val();
            if (field.trim().length == 0) {
                value.next('div.red').remove();
                value.after("<div class=\'red\'>" + "\'" + label + "\' is Required</div>");
                errors.push(value.attr('id') + "_required");
            } else {
                value.next('div.red').remove();
                errors = removeError(errors, value.attr('id') + "_required");
            }
            makeAllButtonsActive(value);
        }

        function emailValidation(value, label) {

            var field = value.val();
            var re = /\S+@\S+\.\S+/;
            if ((!re.test(field)) && (field.trim().length != 0)) {
                value.next('div.red').remove();
                value.after("<div class=\'red\'>" + "\'" + label + "\' is not correct</div>");
                errors.push(value.attr('id') + "_not_valid");
            } else {
                errors = removeError(errors, value.attr('id') + "_not_valid");
            }
            makeAllButtonsActive(value);
        }

        function digitsValidation(value, label) {
            var field = value.val();
            var onlyDigits = /^\d*$/;
            if ((!onlyDigits.test(field)) && (field.trim().length != 0)) {
                value.next('div.red').remove();
                value.after("<div class=\'red\'>" + "\'" + label + "\' . Only numbers are allowed.</div>");
                errors.push(value.attr('id') + "_not_valid");
            } else {
                errors = removeError(errors, value.attr('id') + "_not_valid");
            }
            makeAllButtonsActive(value);
        }


        function emptySpecialValidation(value, label) {
            var field = value.val();
            if (field.trim().length == 0) {
                value.parent().next('div.red').remove();
                value.parent().after("<div class=\'red\'>" + "\'" + label + "\' is Required</div>");
                errors.push(value.attr('id') + "_required");
            } else {
                value.parent().next('div.red').remove();
                errors = removeError(errors, value.attr('id') + "_required");
            }
            makeAllButtonsActive(value);
        }
        function emptySpecial2Validation(value, label) {
            var field = value.val();
            if (field.trim().length == 0) {
                value.parent().parent().next('div.red').remove();
                value.parent().parent().after("<div class=\'red\'>" + "\'" + label + "\' is Required</div>");
                errors.push(value.attr('id') + "_required");
            } else {
                value.parent().parent().next('div.red').remove();
                errors = removeError(errors, value.attr('id') + "_required");
            }
            makeAllButtonsActive(value);
        }
        function emptytotalPackageValidation(value, label) {
            var field = value.val();
            if (field.trim().length == 0) {
                value.parent().next('div.red').remove();
                value.parent().after("<div class=\'red\'>" + "\'" + label + "\' is Required</div>");
                errors.push(value.attr('id') + "_required");
            } else {
                value.parent().next('div.red').remove();
                errors = removeError(errors, value.attr('id') + "_required");
            }
            makeAllButtonsActive(value);
        }

        function removeError(newArray, removeItem) {
            var newArray = jQuery.grep(newArray, function (value) {
                return value != removeItem;
            });
            return newArray;
        }

        function makeAllButtonsActive(value) {

            if ($("#orderNumber").val().trim() === "") {
                $("html, body").animate({scrollTop: 0}, "slow");
            }

            var empty = false;
            if (value.attr('id') == 'orderNumber') {
                value = $("#receiverName")
            }

            value.closest('.create-shipping-block-body').find('input[type="text"]').each(function () {
                if ($(this).val().trim() == "" && $(this).hasClass('valid')) {
                    empty = true;
                    return false;
                }
            });

                 if (errors.length === 0 && empty === false) {

                    value.closest('.create-shipping-block-body').find(".button-next").removeClass('passive');
                    value.closest('.create-shipping-block').find(".create-shipping-block-top").addClass('unblocked');
                    value.closest('.create-shipping-block').prev().find(".create-shipping-block-top").addClass('unblocked');
                } else {
                    value.closest('.create-shipping-block-body').find(".button-next").addClass('passive');

                }
        }

		makeAllButtonsActive($("#receiverName"));

        $(".reciver .main-red-button-shipment").click(function () {
			makeAllButtonsActive($("#goodsDescription"));
        });	

        $(".detailes .main-red-button-shipment").click(function () {
			makeAllButtonsActive($("#totalPackagesWeight"));
        });	


        $(".create-shipping-block-top").click(function () {
        	if($(this).hasClass('unblocked')){
            if ($(this).hasClass('active-top')) {
                $(this).removeClass('active-top').removeClass('active');
                $(this).next().hide();
                $(this).find('.triangle').removeClass('active');

            } else {
                $(this).addClass('active-top').addClass('active');
                $(this).next().fadeIn("slow");
                $(this).find('.triangle').addClass('active');

            }
        	}
        });	


        $(".checkSingle").click(function () {
        	if ($(this).attr('checked') !== "checked") {
 				$(this).attr('checked', true);
 				$(".block-insurance .filter-block-select").fadeIn("fast");
        	}else{
 				$(this).attr('checked', false); 
 				$(".block-insurance .filter-block-select").hide();
        	}
        });	


        $("#reciverPhone").intlTelInput({
            // options here
        });
        // jQuery 
        $("#reciverMobile").intlTelInput({
            // options here
        });
        // jQuery 
        $("#originPhone").intlTelInput({
            // options here
        });
        // jQuery 
        $("#originMobile").intlTelInput({
            // options here
        });
