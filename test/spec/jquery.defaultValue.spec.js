describe('jQuery form element defaultValue plugin', function() {
    'use strict';

    describe('input element', function() {
        beforeEach(function() {
            this.$fixture = setFixtures('<input type="text" id="e">');
            this.$e = $('input', this.$fixture);
        });

        it('should return empty default value', function() {
            expect(this.$e.defaultValue()).toEqual('');
        });

        it('should return correct default value', function() {
            this.$fixture = setFixtures('<input type="text" id="e" value="hello">');
            this.$e = $('input', this.$fixture);
            expect(this.$e.defaultValue()).toEqual('hello');
        });

        it('should return value based on first element if there\'s more than one element', function() {
            this.$fixture.prepend('<input type="text" value="123">');
            this.$e = $('input', this.$fixture);
            expect(this.$e.defaultValue()).toEqual('123');
        });

        it('shoud update defaultValue correctly', function() {
            var v = 'updated value';
            this.$e.defaultValue(v);
            expect(this.$e.defaultValue()).toEqual(v);
        });

        it('shoud sync defaultValue correctly', function() {
            var v = 'updated value';
            this.$e.val(v);
            this.$e.syncDefaultValue();
            expect(this.$e.defaultValue()).toEqual(v);
        });
    });

    describe('select element', function() {
        beforeEach(function() {
            this.$fixture = setFixtures('<select id="e">' +
                                        '<option value="1"></option>' +
                                        '<option value="2"></option>' +
                                        '</select>');
            this.$e = $('select', this.$fixture);
        });

        it('should return empty default value', function() {
            expect(this.$e.defaultValue()).toEqual('');
        });

        it('should return correct default value', function() {
            this.$fixture = setFixtures('<select id="e">' +
                                        '<option value="1"></option>' +
                                        '<option value="2" selected></option>' +
                                        '</select>');
            this.$e = $('select', this.$fixture);
            expect(this.$e.defaultValue()).toEqual('2');
        });

        it('shoud update defaultValue correctly', function() {
            var v = 2;
            this.$e.defaultValue(v);
            expect(this.$e.defaultValue()).toEqual(v.toString());

            this.$e.defaultValue(v);
            expect(this.$e.defaultValue()).toEqual(v.toString());
        });

        it('shoud sync defaultValue correctly', function() {
            var o = this.$e.find('option')[0];
            o.selected = true;
            var v = o.value;

            this.$e.syncDefaultValue();

            expect(this.$e.defaultValue()).toEqual(v);
        });
    });
});
