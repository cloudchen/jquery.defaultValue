describe 'jQuery form element defaultValue plugin', ->
  describe 'input element', ->
    beforeEach ->
      @$fixture = setFixtures('<input type="text" id="e">')
      @$e = $('input', @$fixture)

    it 'should return empty default value', ->
      expect(@$e.defaultValue()).toEqual ''

    it 'should return correct default value', ->
      @$fixture = setFixtures('<input type="text" id="e" value="hello">')
      @$e = $('input', @$fixture)
      expect(@$e.defaultValue()).toEqual 'hello'

    it 'should return value based on first element if there\'s more than one element', ->
      @$fixture.prepend '<input type="text" value="123">'
      @$e = $('input', @$fixture)
      expect(@$e.defaultValue()).toEqual '123'

    it 'shoud update defaultValue correctly', ->
      v = 'updated value'
      @$e.defaultValue v
      expect(@$e.defaultValue()).toEqual v

    it 'shoud sync defaultValue correctly', ->
      v = 'updated value'
      @$e.val v
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual v


  describe 'select element', ->
    beforeEach ->
      @$fixture = setFixtures('<select id="e">' + '<option value="1"></option>' + '<option value="2"></option>' + '</select>')
      @$e = $('select', @$fixture)

    it 'should return empty default value', ->
      expect(@$e.defaultValue()).toEqual ''

    it 'should return correct default value', ->
      @$fixture = setFixtures('<select id="e">' + '<option value="1"></option>' + '<option value="2" selected></option>' + '</select>')
      @$e = $('select', @$fixture)
      expect(@$e.defaultValue()).toEqual '2'

    it 'shoud update defaultValue correctly', ->
      v = 2
      @$e.defaultValue v
      expect(@$e.defaultValue()).toEqual v.toString()
      @$e.defaultValue v
      expect(@$e.defaultValue()).toEqual v.toString()

    it 'shoud sync defaultValue correctly', ->
      o = @$e.find('option')[0]
      o.selected = true
      v = o.value
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual v

    it 'shoud sync defaultValue correctly if defaultValue existed before', ->
      @$fixture = setFixtures('<select id="e">' + '<option value="1" selected></option>' + '<option value="2"></option>' + '</select>')
      @$e = $('select', @$fixture)
      o = @$e.find('option')[1]
      o.selected = true
      v = o.value
      @$e.syncDefaultValue()
      expect(@$e.defaultValue()).toEqual v
