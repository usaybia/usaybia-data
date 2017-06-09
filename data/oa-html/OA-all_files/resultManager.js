$(document).ready(function() {

    var $infinite;

    //au chargement de la page on va cacher les critères que l'on a pas besoin 
    var urlLoadSavedCriteria = $('#criteriaView').data('url');
    $.get(urlLoadSavedCriteria, loadCriteria);

    //infinite scrolling 
    var $window = $(window);
    if ($('#result').data('url') != undefined) {
        $window.scroll(function() {
            if (($(this).height() + $window.scrollTop()) > ($(document).height() - 150)) {
                logoChargement = $('<p id="logoLoad" style="text-align:center"><img src="/img/ajax-loader.gif"/></p>');
                if (!$('#logoLoad').length && !$('#endOfList').length) {
                    $('#result').append(logoChargement);
                    // var oForm = {};
                    // $('form#formCriteria input').each(function() {
                    //     oForm[this.name] = this.value;
                    // });
                    var oForm = getInputs('form#formCriteria input, form#formCriteria select');
                    $.ajax({
                        type: 'POST',
                        async: false,
                        url: $('#result').data('url'),
                        data: {
                            from: 1 + $('#result').children('.entryContainer').length,
                            scrolling: true,
                            formRecherche: oForm,
                            champTri: null, //dév ultérieur
                            sensTri: null //dév ultérieur
                        },
                        success: function(data) {
                            $(data).hide();
                            $('#result').append($(data));
                            // logoChargement.remove();
                            $('#logoLoad').remove();
                            $(data).fadeIn();
                            //on réattribue les fonctions qui permettent de gérer la visibilité des notices
                            $('.changeType').off();
                            managerType();
                            //on cache les critères que l'on a pas besoin 
                            $.get(urlLoadSavedCriteria, loadCriteria);
                        }
                    });
                }
            }
        });
    }

    //on gere l affichage des resultats
    $('.btn_switch_display').on('click', function(e) {
        e.preventDefault();
        if ($(this).hasClass('btn-active')) {
            return false;
        }
        $('body').addClass('loading');
        var url = $(this).attr('href');

        switch ($(this).attr('id')) {
            case 'switch_display_cumulative':
                params = {
                    'displaymode': 'cumulative'
                };
                setBtnActive('#switch_display_cumulative', '.btn_switch_display');
                break;
            case 'switch_display_successive':
                params = {
                    'displaymode': 'successive'
                };
                setBtnActive('#switch_display_successive', '.btn_switch_display');
                break;
            case 'switch_display_detailed':
                params = {
                    'displaymode': 'detailed'
                };
                setBtnActive('#switch_display_detailed', '.btn_switch_display');
        }

        $('#result').load(url, params, function() {
            $.get(urlLoadSavedCriteria, loadCriteria);
        });

    });

    //on gere l affichage d un personnage
    $('.btn_switch_layout').on('click', function(e) {
        e.preventDefault();
        if ($(this).hasClass('btn-active')) {
            return false;
        }
        $('body').addClass('loading');
        var url = $(this).attr('href');
        if ($('#searchCriteria').length) {
            // var oForm = {};
            // $('form#formCriteria [name]').each(function() {
            //     oForm[this.name] = this.value;
            // });
            var oForm = getInputs('form#formCriteria [name]');
            switch ($(this).attr('id')) {
                case 'switch_layout_horizontal':
                    oForm['viewmode'] = 'horizontal';
                    $('#switch_layout_vertical').removeClass('btn-active');
                    $('#switch_layout_horizontal').addClass('btn-active');
                    break;
                case 'switch_layout_vertical':
                    oForm['viewmode'] = 'vertical';
                    $('#switch_layout_vertical').addClass('btn-active');
                    $('#switch_layout_horizontal').removeClass('btn-active');
                    break;
            }

            $('#result').load(url, {
                formRecherche: oForm
            }, function() {
                $.get(urlLoadSavedCriteria, loadCriteria);
                $('body').removeClass('loading');

            });
        }
        //on est dans le cas où regarde l'entrée seule
        else {
            id = $('#result table').data('id');
            if (id) {
                switch ($(this).attr('id')) {
                    case 'switch_layout_horizontal':
                        params = {
                            'idEntry': id,
                            'viewmode': 'horizontal'
                        };
                        $('#switch_layout_vertical').removeClass('btn-active');
                        $('#switch_layout_horizontal').addClass('btn-active');
                        break;
                    case 'switch_layout_vertical':
                        params = {
                            'idEntry': id,
                            'viewmode': 'vertical'
                        };
                        $('#switch_layout_vertical').addClass('btn-active');
                        $('#switch_layout_horizontal').removeClass('btn-active');
                        break;
                }
                // $entryContainer = $('<div class="entryContainer"></div>');
                // $('#result').html($entryContainer);
                $('#result').load(url, params, function() {
                    $.get(urlLoadSavedCriteria, loadCriteria);
                    $('body').removeClass('loading');

                });
            }
        }
    });

    //on gere ici l affichage des categories
    $('#entry_manager').on('click', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');
        $.get(url, function(data) {

            //boite de dialog pour gérer l'affichage des critères
            $mydialog = $(data);
            $('#criteriaView').html($mydialog);
            $categoryViewer = $mydialog.dialog({
                autoOpen: true,
                appendTo: "#criteriaView",
                modal: true,
                minWidth: 400,
            });
            $categoryViewer.dialog('open');

            $('input.checkallsub').each(function(i, e) {
                className = $(this).attr('id');
                if ($('input.' + className + ':checked').length) {
                    $(this).prop('checked', true);
                }
            });

            $('input.checkallsub').on('change', function(e) {
                $(this).prop('checked');
                className = $(this).attr('id');
                if ($(this).is(':checked')) {
                    $(this).prop('checked', true);
                    $('input.' + className).prop('checked', true);
                } else {
                    $(this).prop('checked', false);
                    $('input.' + className).prop('checked', false);
                }
            });

            $('#form_categories_save').on('click', function(e) {
                $('body').addClass('loading');
                //on empêche le changement de page
                e.preventDefault();

                //on récupère les critères séléctionnés et pour chaque on va cacher ou montrer les données correspondantes
                $categories = $('#manager_modal input[type=checkbox]');

                $categories.each(function(index, element) {
                    category = $.trim($(element).parent('label').text());

                    // category = $('label[for='+$(element).attr('id')+']').text();
                    if ($(element).is(':checked')) {
                        $('table.entry .' + category).removeClass('hide');
                    } else {
                        $('table.entry .' + category).addClass('hide');
                    }
                });

                formData = {
                    'data': $('div#manager_modal form').serializeArray()
                };
                //on sauvegarde en session les critères choisis
                $.post(url, formData, function() {

                });

                // $categoryViewer.dialog('destroy');
                $categoryViewer.dialog('close');
                // $categoryViewer.dialog('destroy');//pour supprimer le html construit
                $('body').removeClass('loading');
                // $('#criteriaView').html('');

                return false;
            });
        });

        return false;
    });

    $('a#sorting_options').on('click', function(e) {
        e.preventDefault();
        var url = $(this).attr('href');

        //boite de dialog pour gérer l'affichage des critères
        $mydialog = $('#sort_options');
        $sortOptionsDialog = $mydialog.dialog({
            autoOpen: true,
            appendTo: '#formCriteria',
            modal: true,
            minWidth: 400,
        });
        $sortOptionsDialog.dialog('open');
        $('#sort_category').on('click', function(e) {
            e.preventDefault();

            $sortOptionsDialog.dialog('close');
            $('body').addClass('loading');
            var oForm = getInputs('form#formCriteria [name]');
            var urlResult = $('#result').data('url');
            $('#result').load(urlResult, {
                formRecherche: oForm
            }, function() {
                $.get(urlLoadSavedCriteria, loadCriteria);

                // $sortOptionsDialog.html('');
            });
        });
    });

});

function loadCriteria(data) {
    //on récupère les données json
    var $checkedCat = JSON.parse(data);

    //on cache chaque cellules
    $('table.entry .ligne').addClass('hide');
    $('table.entry .colonne').addClass('hide');
    //on fait apparaître les cellules qui ne devaient pas être cachés (selon données récupérées en sessions)
    $.each($checkedCat, function(index, element) {
        if ($('table.entry .' + element).hasClass('hide'))
            $('table.entry .' + element).removeClass('hide');
    });

    $('body').removeClass('loading');
}

function checkAll() {
    $(input[type = checkbox]).prop('checked', true);
}

function uncheckAll() {
    $(input[type = checkbox]).prop('checked', false);
}

function getInputs(selector) {
    var oForm = {};
    $(selector).each(function() {
        oForm[this.name] = this.value;
    });
    return oForm;
}

function setBtnActive(idBtn, classBtn) {
    $(classBtn).removeClass('btn-active');
    $(idBtn).addClass('btn-active');
}