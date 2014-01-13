describe 'jQuery form element defaultValue plugin', ->
  describe 'input element', ->
    beforeEach ->
      @$fixture = setFixtures '<input type="text" id="e">'
      @$e = $('input', @$fixture)

    it 'should return empty string', ->
      expect(@$e.defaultValue()).toEqual ''

    it 'should return correct default value', ->
      @$fixture = setFixtures '<input type="text" id="e" value="hello">'
      @$e = $('input', @$fixture)
      expect(@$e.defaultValue()).toEqual 'hello'

    it 'should return default value for the first element in the set of matched elements', ->
      @$fixture.prepend '<input type="text" value="123">'
      @$e = $('input', @$fixture)
      expect(@$e.defaultValue()).toEqual '123'

      @$e.val '456'
      expect(@$e.defaultValue()).toEqual '123'

      @$fixture.prepend '<input type="text">'
      @$e = $('input', @$fixture)
      expect(@$e.defaultValue()).toEqual ''

    it 'should update defaultValue correctly', ->
      v = 'updated value'
      @$e.val 'not default value'
      expect(@$e.defaultValue()).not.toEqual v
      @$e.defaultValue v
      expect(@$e.defaultValue()).toEqual v

    it 'should update defaultValue correctly for all matched elements', ->
      v = 'updated value'
      @$fixture = setFixtures '<input type="text">
                               <input type="email">
                               <input type="tel">
                               <input type="password">'
      @$e = $('input', @$fixture)

      @$e.val 'not default value'
      @$e.defaultValue v
      @$e.each ->
        expect($(this).val()).not.toEqual v
        expect($(this).defaultValue()).toEqual v

    it 'should sync defaultValue correctly', ->
      v = 'updated value'
      @$e.val v
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual v

    it 'should sync defaultValue correctly for all matche elements', ->
      v = 'updated value'
      @$fixture = setFixtures '<input type="text">
                               <input type="email">
                               <input type="tel">
                               <input type="password">'
      @$e = $('input', @$fixture)

      @$e.val v
      @$e.syncDefaultValue()
      @$e.each ->
        expect($(this).defaultValue()).toEqual v


  describe 'hidden field', ->
    beforeEach ->
      @$fixture = setFixtures '<input type="hidden" value="1">'
      @$e = $('input', @$fixture)

    it 'should have exactly same defaultValue property with value property', ->
      v = @$e.val()
      expect(@$e.defaultValue()).toEqual v

    it 'defaultValue property should be synced every time its value property is changed', ->
      v = '2'
      @$e.val v
      expect(@$e.defaultValue()).toEqual v

    it 'value property should be synced every time its defaultValue property is changed ', ->
      v = '2'
      @$e.defaultValue v
      expect(@$e.val()).toEqual v


  describe 'select element', ->
    beforeEach ->
      @$fixture = setFixtures '<select id="e">
                               <option value="1"></option>
                               <option value="2"></option>
                               </select>'
      @$e = $('select', @$fixture)

    it 'should return undefined default value', ->
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should return correct default value', ->
      @$fixture = setFixtures '<select id="e">
                               <option value="1"></option>
                               <option value="2" selected></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toEqual '2'

    it 'should return correct default value for the first element
        in the set of matched elements', ->
      @$fixture = setFixtures '<select id="a">
                               <option value="a"></option>
                               <option value="b"></option>
                               </select>
                               <select id="e">
                               <option value="1"></option>
                               <option value="2" selected></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should update defaultValue correctly', ->
      o = @$e.find('option').eq(1)
      v = o.val()
      o.prop('selected', true)
      expect(@$e.defaultValue()).not.toEqual v
      @$e.defaultValue v
      expect(@$e.defaultValue()).toEqual v

    it 'should update defaultValue correctly of multiple matched elements', ->
      @$fixture = setFixtures '<select>
                               <option value="a"></option>
                               <option value="b"></option>
                               </select>
                               <select>
                               <option value="1"></option>
                               <option value="2" selected></option>
                               <option value="a"></option>
                               </select>
                               <select>
                               <option value="hello"></option>
                               <option value="a" selected></option>
                               <option value="world"></option>
                               </select>'

      @$e = $('select', @$fixture)
      v = 'a'
      @$e.defaultValue v
      @$e.each (i, element)->
        expect($(element).defaultValue()).toBe v

    it 'should sync defaultValue correctly', ->
      o = @$e.find('option')[0]
      o.selected = true
      v = o.value
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual v
      expect(@$e.eq(0).defaultValue()).toEqual v
      expect(@$e.eq(1).defaultValue()).toBeUndefined()

    it 'should sync defaultValue correctly of matched elements
        if defaultValue was existed before', ->
      @$fixture = setFixtures '<select>
                               <option></option>
                               <option value="b"></option>
                               </select>
                               <select>
                               <option value="1" selected></option>
                               <option value="2"></option>
                               <option value="a"></option>
                               </select>
                               <select>
                               <option value="hello"></option>
                               <option value="a" selected></option>
                               <option value="world"></option>
                               </select>'

      @$e = $('select', @$fixture)
      selectedIndexes = [0, 1, 2]
      selectedValues = ['', '2', 'world']
      @$e.each (i)->
        this.options[selectedIndexes[i]].selected = true

      @$e.syncDefaultValue()
      @$e.each (i)->
        expect($(this).defaultValue()).toBe selectedValues[i]


  describe 'multiple select element', ->
    it 'should return undefined default value', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="1"></option>
                               <option value="2"></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should return array as default value when one option is selected', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="1"></option>
                               <option value="2"></option>
                               <option value="3" selected></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toEqual ['3']

    it 'should return array as default value when multiple options are selected', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="1" selected></option>
                               <option value="2"></option>
                               <option value="3" selected></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toEqual ['1', '3']

    it 'should return correct default value for the first element
        in the set of matched elements', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="a"></option>
                               <option value="b"></option>
                               </select>
                               <select multiple>
                               <option value="1"></option>
                               <option value="2" selected></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toBeUndefined()
      
      @$fixture = setFixtures '<select multiple>
                               <option value="1"></option>
                               <option value="2" selected></option>
                               </select>
                               <select multiple>
                               <option value="a"></option>
                               <option value="b"></option>
                               </select>'
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toEqual ['2']

    it 'should update defaultValue correctly', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="1" selected></option>
                               <option value="2"></option>
                               <option value="3"></option>
                               </select>'
      @$e = $('select', @$fixture)

      o = @$e.find('option').eq(1)
      o.prop('selected', true)

      o = @$e.find('option').eq(2)
      o.prop('selected', true)

      v = ['2', '3']

      expect(@$e.defaultValue()).toEqual ['1']
      expect(@$e.defaultValue()).not.toEqual v
      @$e.defaultValue.apply(@$e, v)
      expect(@$e.defaultValue()).toEqual v

    it 'should update defaultValue correctly of multiple matched elements', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="a"></option>
                               <option value="b"></option>
                               <option value="1" selected></option>
                               </select>
                               <select multiple>
                               <option value="1"></option>
                               <option value="2" selected></option>
                               <option value="a"></option>
                               </select>
                               <select multiple>
                               <option value="hello"></option>
                               <option value="a" selected></option>
                               <option value="world"></option>
                               <option value="1"></option>
                               </select>'

      @$e = $('select', @$fixture)
      v = ['a', '1']
      @$e.defaultValue.apply(@$e, v)
      @$e.each (i, element)->
        for value in v
          expect($(element).defaultValue()).toContain value

    it 'should sync defaultValue correctly', ->
      @$fixture = setFixtures '<select multiple>
                               <option value="1" selected></option>
                               <option value="2"></option>
                               <option value="3"></option>
                               </select>'
      @$e = $('select', @$fixture)

      @$e.find('option').eq(0).prop('selected', false)
      o = @$e.find('option').slice(1)
      o.prop('selected', true)
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual ['2','3']

    it 'should sync defaultValue correctly of matched elements
        if defaultValue was existed before', ->
      @$fixture = setFixtures '<select multiple>
                               <option></option>
                               <option value="b"></option>
                               </select>
                               <select multiple>
                               <option value="1" selected></option>
                               <option value="2"></option>
                               <option value="a"></option>
                               </select>
                               <select multiple>
                               <option value="hello"></option>
                               <option value="a" selected></option>
                               <option value="world"></option>
                               </select>'

      @$e = $('select', @$fixture)
      selectedIndexes = [[0,1], [1,2], [0,1,2]]
      selectedValues = [['','b'], ['1', '2','a'], ['hello','a','world']]
      @$e.each (i)->
        for index in selectedIndexes[i]
          this.options[index].selected = true

      @$e.syncDefaultValue()
      @$e.each (i)->
        expect($(this).defaultValue()).toEqual selectedValues[i]


  describe 'checkbox element', ->
    beforeEach ->
      @$fixture = setFixtures '<form>
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2">
                               </form>'
      @$e = @$fixture.find document.forms[0].elements['test']

    it 'should return empty defaultValue', ->
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should return undefined if frist element in matched elements is unchecked', ->
      @$fixture = setFixtures '<form>
                               <input type="checkbox" name="aa" value="1">
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2" checked></form>'
      @$e = @$fixture.find 'input'
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should return current value as defaultValue
        if frist element in matched elements is checked', ->
      @$fixture = setFixtures '<input type="checkbox" name="aa" value="1" checked>
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2" checked>'
      @$e = @$fixture.find 'input'
      expect(@$e.defaultValue()).toEqual '1'

    it 'should return current value of first element in matched elements as defaultValue
        event if multiple checkboxs are checked', ->
      @$fixture = setFixtures '<input type="checkbox" name="aa" value="1" checked>
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2" checked>'
      @$e = @$fixture.find 'input'
      expect(@$e.defaultValue()).toEqual '1'

    it 'should return browser presetted value as defaultValue if value is not specified', ->
      @$fixture = setFixtures '<input type="checkbox" name="test" checked>
                               <input type="checkbox" name="test">'
      @$e = @$fixture.find 'input[type="checkbox"]'
      @$fixture.append('<input type="checkbox" id="a" checked>')
      browser_value = $('#a', @$fixture)[0].value
      expect(@$e.defaultValue()).toEqual browser_value

    it 'should update defaultValue with specified value of single element', ->
      @$fixture = setFixtures '<input type="checkbox" name="test">'
      @$e = @$fixture.find 'input[type="checkbox"]'
      @$fixture.append('<input type="checkbox" id="a" checked>')
      browser_value = $('#a', @$fixture)[0].value

      @$e.defaultValue(true)
      expect(@$e.defaultValue()).toBe browser_value
      @$e.defaultValue(false)
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should update defaultValue with specified value of all matched elements', ->
      @$fixture = setFixtures '<input type="checkbox" name="test" checked>
                               <input type="checkbox" name="test">
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2" checked>'
      @$e = @$fixture.find 'input[type="checkbox"]'
      @$fixture.append('<input type="checkbox" id="a" checked>')
      browser_value = $('#a', @$fixture)[0].value

      updated_value = [false, true, true, false]
      results = [undefined, browser_value, '1', undefined]
      @$e.each (i)->
        $(this).defaultValue(updated_value[i])
        expect($(this).defaultValue()).toBe results[i]

    it 'should sync defaultValue with current checked status of all matched elements', ->
      @$fixture = setFixtures '<input type="checkbox" name="test" checked>
                               <input type="checkbox" name="test">
                               <input type="checkbox" name="test" value="1">
                               <input type="checkbox" name="test" value="2" checked>'
      @$e = @$fixture.find 'input[type="checkbox"]'
      @$fixture.append('<input type="checkbox" id="a" checked>')
      browser_value = $('#a', @$fixture)[0].value

      @$e.click()
      results = [undefined, browser_value, '1', undefined]
      @$e.syncDefaultValue().each (i)->
        expect($(this).defaultValue()).toBe results[i]

      @$e.eq(1).click()
      @$e.eq(3).click()
      results = [undefined, undefined, '1', '2']
      @$e.syncDefaultValue().each (i)->
        expect($(this).defaultValue()).toBe results[i]


  describe 'radio element', ->
    beforeEach ->
      @$fixture = setFixtures '<input type="radio" name="test" value="1">
                               <input type="radio" name="test" value="2" checked>'
      @$e = @$fixture.find 'input[type="radio"]'

    it 'should return undefined if defaultchecked status is false', ->
      expect(@$e.eq(0).defaultValue()).toBeUndefined

    it 'should return value property as defaultValue if defaultchecked status is true', ->
      expect(@$e.eq(1).defaultValue()).toBe '2'

    it 'should return defaultValue of first element of matched elements', ->
      expect(@$e.defaultValue()).toBeUndefined

      @$fixture = setFixtures '<input type="radio" name="test" value="1" checked>
                               <input type="radio" name="test" value="2">'
      @$e = @$fixture.find 'input[type="radio"]'

      expect(@$e.defaultValue()).toBe '1'

    it 'should update defaultValue correctly for no matter how many matched elements', ->
      @$e.defaultValue true
      @$e.each ->
        expect($(this).defaultValue()).toBe this.value

      @$e.eq(0).defaultValue false
      expect(@$e.eq(0).defaultValue()).toBeUndefined

    it 'should sync defaultValue with current checked status of all matched elements', ->
      @$fixture = setFixtures '<input type="radio" name="test" value="1">
                               <input type="radio" name="test" value="2" checked>
                               <input type="radio" name="t2" value="a">
                               <input type="radio" name="t2" value="b">
                               '
      @$e = @$fixture.find 'input[type="radio"]'
      @$e.eq(0).prop('checked', true)
      @$e.eq(3).prop('checked', true)

      results = ['1', undefined, undefined, 'b']
      @$e.syncDefaultValue()
      @$e.each (i)->
        expect($(this).defaultValue()).toBe results[i]


  describe 'non-html form element', ->
    beforeEach ->
      @$fixture = setFixtures '<div id="e"></div>'
      @$e = @$fixture.find '#e'

    it 'should return undefined', ->
      expect(@$e.defaultValue()).toBeUndefined()

    it 'should not update defaultValue property', ->
      v = 'updated value'
      @$e.defaultValue(v)
      expect(@$e.defaultValue()).toEqual v


