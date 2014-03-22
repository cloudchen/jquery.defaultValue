jquery.defaultValue
===================
[![Build Status](https://travis-ci.org/cloudchen/jquery.defaultValue.png?branch=master)](https://travis-ci.org/cloudchen/jquery.defaultValue)
[![Coverage Status](https://coveralls.io/repos/cloudchen/jquery.defaultValue/badge.png)](https://coveralls.io/r/cloudchen/jquery.defaultValue)
[![Dependency Status](https://david-dm.org/cloudchen/jquery.defaultValue.png)](https://david-dm.org/cloudchen/jquery.defaultValue)
[![devDependency Status](https://david-dm.org/cloudchen/jquery.defaultValue/dev-status.png)](https://david-dm.org/cloudchen/jquery.defaultValue#info=devDependencies)

> Getting, setting and sync defaultValue with value property of HTML form elements via jQuery

Summary
===================
jQuery defaultValue plugin works exactly like .val() native method except returns defaultValue rather than value property.

Installation
===================
[![Bower version](https://badge.fury.io/bo/jquery.defaultValue.png)](http://badge.fury.io/bo/jquery.defaultValue)

`bower install jquery.defaultValue`

API Reference
===================
* `defaultValue()` -> String | Array

    Get defaultValue of first element in the set of matched elements

* `defaultValue(value)` (String, Array) -> jQuery

    Set defaultValue of each matched element

* `syncDefaultValue()` -> jQuery

    Sync defaultValue with current value of each matched element


Usage
===================

### Get the defaultValue of **first element** in the set of matched elements

- For **text input** element, it returns value based on its `defaultValue` property.

> ```html
<input type="text" value="foo">
<input type="text" value="bar">
```
```javascript
$('input:text').defaultValue();
$('input:text').eq(1).defaultValue();
```
Expected result:
```javascript
"foo"
"bar"
```

- For **single select** element, it returns value of nested option that `defaultSelected` equals true.

> ```html
<select>
  <option value="foo">foo text</option>
  <option value="bar" selected>bar text</option>
</select>
```
```javascript
$('select').defaultValue();
```
Expected result:
```javascript
"bar"
```

- For **multiple select** element, it returns array of values of nested option that `defaultSelected` equals true.

> ```html
<select multiple>
  <option value="hello">hello text</option>
  <option value="foo" selected>foo text</option>
  <option value="bar" selected>bar text</option>
  <option value="world">world text</option>
</select>
```
```javascript
$('select').defaultValue();
```
Expected result:
```javascript
["foo", "bar"]
```

-  For checkbox input element, it returns value that is based on its `defaultChecked` property.

> ```html
<input type="checkbox" value="foo" checked>
<input type="checkbox" value="bar">
```
```javascript
$('input:checkbox').defaultValue();
$('input:checkbox').eq(1).defaultValue();
```
Expected result:
```javascript
"foo"
undefined
```

-  For radio input element, it returns value that is based on its `defaultChecked` property.

> ```html
<input type="radio" value="foo">
<input type="radio" value="bar" checked>
```
```javascript
$('input:radio').defaultValue();
$('input:radio').eq(1).defaultValue();
```
Expected result:
```javascript
undefined
"bar"
```

### Set the defaultValue of each matched element

For text input element, native DOM `deafultValue` property of each matched element will be updated to specified value.

> ```javascript
$('input:text').defaultValue(value);
```

For **single select** element, `defaultSelected` property of option with specified value will be updated to `true`.

> ```html
<select>
  <option value="foo" selected>foo</option>
  <option value="bar">bar</option>
</select>
```
```javascript
$('select').defaultValue('bar');
```
Expected result:
```javascript
$('select').defaultValue();
-> "bar"
```

For **multiple select** element, it accepts an array as value.

> ```html
<select multiple>
  <option value="foo" selected>foo</option>
  <option value="bar">bar</option>
  <option value="baz">baz</option>
</select>
```
```javascript
$('select').defaultValue(['bar', 'baz']);
```
Expected result:
```javascript
$('select').defaultValue();
-> ["bar", "baz"]
```

For **checkbox** element, it accpets an boolean status as value.

> ```html
<input type="checkbox" checked>
```
```javascript
$('input:checkbox').defaultValue(false);
```
Expected result:
```javascript
$('input:checkbox').defaultValue();
-> false
```

For **radio** element, it works exactly same with checkbox element.

### Sync the defaultValue with value property of each matched element

`syncDefaultValue()` is helper method for simply sync defaultValue by current value property.

#### Best usage scenario
Sometimes, we'd sync defaultValue for all form elments after the form has been submitted via Ajax.

Here's the typical code for that scenario:
```javascript
var form = document.forms[0];
$.post(form.attr('action'), form.serialize())
 .done(function(){
   $(form.elements).syncDefaultValue();
 });
```

Change Log
===================
* v0.1.0, 21.03.14, First release
