jekyll-toc-generator
====================

Liquid filter to generate Table of Content into Jekyll pages 

This filter adds to jekyll pages a Table of Content (TOC), it generates the necessary HTML code.

# Example

The image below shows the result for the markdown page [alignRules.md](https://raw.github.com/visualdiffer/visualdiffer.github.com/master/alignRules.md)

![image](TOC-Sample.png)

# Installation

### Prerequisites

To use tocGenerator.rb you need [nokogiri](http://nokogiri.org/)

1. copy the file `tocGenerator.rb` into the `_plugins` folder
2. copy the file `css/toc.css` to you css site and include into `_layouts` (this is recommended but not necessary)
2. finished

# How to use

You must replace the `{{ content }}` directive with `{{ content | toc_generate }}`

The output contains the HTML code with the TOC and anchor's targets with the `id` attribute

Example

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset='utf-8' />
        <title>{{ page.title }}</title>
        <!-- This css contains the default style for TOC -->
        <link rel="stylesheet" type="text/css" media="screen" href="css/toc.css">
      </head>
      <body>
        <div>
            {{ content | toc_generate }}
        </div>
      </body>
    </html>

## Style the TOC table

The TOC must have some CSS style to appear correctly, you can find a default implementation into file `css/toc.css`
The style is compatible with mediawiki themes

# Disable generation per page

It is possible to suppress the TOC generation in specific pages, for example the index page normally doesn't have a TOC.  
This can be done into the [Front Matter](http://jekyllrb.com/docs/frontmatter/) section used by jekyll


You must add the `noToc: true` directive

    ---
    permalink: index.html
    layout: default
    title: Main Page with TOC
    noToc: true
    ---


# Advanced configuration

Normally no configuration is necessary but you can set some parameter into you `_config.yml` file

<table>
<tr>
<th>Parameter name</th>
<th>Description</th>
<th>Default value</th>
</tr>

<tr>
<td>minItemsToShowToc</td>
<td>Minimum number of items to show the TOC<br/>Suppose you want to generated the TOC only if there are at least 3 H1</td>
<td>0 (no limit)</td>
</tr>

<tr>
<td>tocTopTag</td>
<td>The top level tag given nokogiri to find<br/>Suppose you want to generated the TOC start form h1 to h5</td>
<td>h1</td>
</tr>
<tr>
<td>anchorPrefix</td>
<td>The prefix used to generate the anchor name</td>
<td>tocAnchor-</td>
</tr>

<tr>
<td>showToggleButton</td>
<td>The TOC has a button used to collapse/expand the list, this requires a little of Javascript
<br/>This package contains a jQuery plugin to handle the click</td>
<td>false</td>
</tr>
</table>

# Toggling the button via jQuery

If the toogle button is visible you can use the jquery plugin included in this repository

Below is shown an usage example

    <!DOCTYPE html>
    <html>
      <head>
        <title>{{ page.title }}</title>
        <!-- This css contains the default style for TOC -->
        <link rel="stylesheet" type="text/css" media="screen" href="css/toc.css">

        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script src="js/jquery.tocLight.js"></script>

        <script type="text/javascript">
            $(function() {
              $.toc.clickHideButton();
            });
      </script>

      </head>
      <body id="small">
            {{ content | toc_generate }}
      </body>
    </html>


# How it works

The filter converts all `H1` and `H2` elements in a parent-child TOC based on how the markdown code is traslated in HTML.
Markdown generates `H1` and `H2` as siblings

For example the markdown code shown below

    heading 1
    =========

    blah blah 

    heading 1.1
    -----------

Generates the following HTML code

    <h1>heading 1</h1>
    <p>blah blah</p>
    <h2>heading 1.1</h2>

# Github pages can't use plugins

If you host your jekyll pages on github you can't run plugins, in this scenario you can use a full javascript solution using [TOC Generator for Markdown](https://github.com/dafi/tocmd-generator)
