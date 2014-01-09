(function($) {'use strict';

    var PROP_MAPPING = {
        'select': 'defaultSelected',
        'radio': 'defaultChecked',
        'checkbox': 'defaultChecked',
        'input': 'defaultValue'
    };

    function getDefaultValue() {
        var me = this;
        //var type = me.attr('type');
        var tagName = me.prop('tagName').toLowerCase();
        var dValue;

        switch (tagName) {
            case 'select':
                dValue = this.find('>option').filter(function() {
                    return this[PROP_MAPPING[tagName]];
                }).val() || '';
                break;
            default:
                dValue = me.prop(PROP_MAPPING[tagName]);
                break;
        }

        return dValue;
    }

    function setDefaultValue(newValue) {
        var me = this;
        var tagName = me.prop('tagName').toLowerCase();

        switch (tagName) {
            case 'select':
                this.find('>option').filter(function() {
                    return this.value === newValue.toString();
                }).prop(PROP_MAPPING[tagName], newValue);
                break;
            default:
                me.prop(PROP_MAPPING[tagName], newValue);
                break;
        }

        return this;
    }

    $.fn.defaultValue = function() {
        if (!arguments.length) {
            return getDefaultValue.call(this);
        } else {
            return setDefaultValue.apply(this, arguments);
        }
    };

    $.fn.syncDefaultValue = function() {
        return setDefaultValue.call(this, this.val());
    };
})(jQuery);
