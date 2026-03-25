# Confluence Storage Format Reference

Confluence pages use a storage format based on XHTML with Atlassian-specific macros. This is the format used in the `body.value` field when creating or updating pages via the REST API.

## Basic HTML Elements

### Text

```html
<p>Paragraph text</p>
<p><strong>Bold text</strong></p>
<p><em>Italic text</em></p>
<p><u>Underline text</u></p>
<p><del>Strikethrough</del></p>
```

### Headings

```html
<h1>Heading 1</h1>
<h2>Heading 2</h2>
<h3>Heading 3</h3>
<h4>Heading 4</h4>
<h5>Heading 5</h5>
<h6>Heading 6</h6>
```

### Lists

Bullet list:

```html
<ul>
  <li>Item one</li>
  <li>Item two</li>
  <li>Item three</li>
</ul>
```

Numbered list:

```html
<ol>
  <li>First</li>
  <li>Second</li>
  <li>Third</li>
</ol>
```

### Tables

```html
<table>
  <thead>
    <tr>
      <th>Header 1</th>
      <th>Header 2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Cell 1</td>
      <td>Cell 2</td>
    </tr>
  </tbody>
</table>
```

### Links

External link:

```html
<a href="https://example.com">Link text</a>
```

Link to another Confluence page:

```html
<ac:link>
  <ri:page ri:content-title="Target Page Title" ri:space-key="SPACE" />
  <ac:plain-text-link-body><![CDATA[Display text]]></ac:plain-text-link-body>
</ac:link>
```

## Confluence Macros

Macros use the `ac:structured-macro` element with an `ac:name` attribute.

### Code Block

```html
<ac:structured-macro ac:name="code">
  <ac:parameter ac:name="language">python</ac:parameter>
  <ac:parameter ac:name="title">Example</ac:parameter>
  <ac:plain-text-body><![CDATA[
def hello():
    print("Hello, world!")
  ]]></ac:plain-text-body>
</ac:structured-macro>
```

Supported languages: `python`, `javascript`, `java`, `bash`, `sql`, `xml`, `json`, `yaml`, `go`, `rust`, `c`, `cpp`, `csharp`, and many more.

### Info / Note / Warning / Tip Panels

```html
<ac:structured-macro ac:name="info">
  <ac:rich-text-body>
    <p>This is an informational message.</p>
  </ac:rich-text-body>
</ac:structured-macro>
```

Replace `info` with:
- `note` -- yellow note panel
- `warning` -- red warning panel
- `tip` -- green tip panel

### Table of Contents

```html
<ac:structured-macro ac:name="toc">
  <ac:parameter ac:name="maxLevel">3</ac:parameter>
</ac:structured-macro>
```

### Expand/Collapse Section

```html
<ac:structured-macro ac:name="expand">
  <ac:parameter ac:name="title">Click to expand</ac:parameter>
  <ac:rich-text-body>
    <p>Hidden content here</p>
  </ac:rich-text-body>
</ac:structured-macro>
```

### Status Macro (Colored Badge)

```html
<ac:structured-macro ac:name="status">
  <ac:parameter ac:name="colour">Green</ac:parameter>
  <ac:parameter ac:name="title">DONE</ac:parameter>
</ac:structured-macro>
```

Colors: `Grey`, `Red`, `Yellow`, `Green`, `Blue`

### Horizontal Rule

```html
<hr />
```

## Common Page Templates

### Simple Documentation Page

```html
<h1>Feature Name</h1>
<ac:structured-macro ac:name="toc" />
<h2>Overview</h2>
<p>Brief description of the feature.</p>
<h2>Details</h2>
<p>Detailed information here.</p>
<h2>Examples</h2>
<ac:structured-macro ac:name="code">
  <ac:parameter ac:name="language">bash</ac:parameter>
  <ac:plain-text-body><![CDATA[echo "example"]]></ac:plain-text-body>
</ac:structured-macro>
```

### Status Page

```html
<h1>Project Status</h1>
<table>
  <tr>
    <th>Component</th>
    <th>Status</th>
    <th>Owner</th>
  </tr>
  <tr>
    <td>API</td>
    <td><ac:structured-macro ac:name="status"><ac:parameter ac:name="colour">Green</ac:parameter><ac:parameter ac:name="title">ON TRACK</ac:parameter></ac:structured-macro></td>
    <td>Alice</td>
  </tr>
</table>
```
