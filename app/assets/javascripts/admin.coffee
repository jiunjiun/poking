#= require rails-ujs

# -- Core scripts --
#= require Appwork/pace
#= require jquery

#= require Appwork/layout-helpers
#= require Appwork/libs/popper/popper

#= require Appwork/bootstrap
#= require Appwork/sidenav
#= require Appwork/demo

# libs
#= require validate/validate
#= require datatables/datatables
#= require bootstrap-slider/bootstrap-slider
#= require chartjs/chartjs

#= require_self
#= require_tree ./admin

$ ->
  $('[data-toggle="tooltip"]').tooltip()

  unless $('.simple_form.ignore').length
    $('.simple_form').validate
      ignore: '.ignore'
      focusInvalid: false
      errorPlacement: (error, element) ->
        $parent = $(element).parents('.form-group')

        # Do not duplicate errors
        return if ($parent.find('.jquery-validation-error').length)

        $parent.append(error.addClass('jquery-validation-error small form-text invalid-feedback'))
      highlight: (element) ->
        $el = $(element)
        $parent = $el.parents('.form-group')

        $el.addClass('is-invalid')

      unhighlight: (element) ->
        $(element).parents('.form-group').find('.is-invalid').removeClass('is-invalid')
