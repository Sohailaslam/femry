
CKEDITOR.editorConfig = function (config) {
  // ... other configuration ...
  config.removePlugins = 'elementspath',
  config.resize_enabled = true,
  config.extraPlugins = 'autogrow'
  config.autoGrow_minHeight = 100,
  config.autoGrow_maxHeight = 600,
  config.autoGrow_bottomSpace = 20,
  config.toolbar_mini = [
    ["Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript"],
  ];
  config.toolbar = "mini";
  config.height = '80px';

  // ... rest of the original config.js  ...
}


