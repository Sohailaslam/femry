
CKEDITOR.editorConfig = function (config) {
  // ... other configuration ...
  config.removePlugins = 'elementspath',
  config.resize_enabled = false,
  config.toolbar_mini = [
    ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
  ];
  config.toolbar = "mini";
  config.height = '80px';

  // ... rest of the original config.js  ...
}


