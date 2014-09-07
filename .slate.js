S.log('[SLATE] ----------- Start Loading Config -----------');

// Config
S.configAll({
  defaultToCurrentScreen: true,

  windowHintsIgnoreHiddenWindows: false,
  windowHintsShowIcons: true,
});

// Key binding
S.bindAll({
  'r:ctrl,cmd': S.op('relaunch'),
  ';:ctrl,cmd': S.op('hint'),

  'h:ctrl,cmd': S.op('push', {direction: 'left', style: 'bar-resize:screenSizeX/2'}),
  'k:ctrl,cmd': S.op('push', {direction: 'up', style: 'bar-resize:screenSizeY/2'}),
  'j:ctrl,cmd': S.op('push', {direction: 'down', style: 'bar-resize:screenSizeY/2'}),
  'l:ctrl,cmd': S.op('push', {direction: 'right', style: 'bar-resize:screenSizeX/2'}),
  'm:ctrl,cmd': S.op('push', {direction: 'right', style: 'bar-resize:screenSizeX/3*2'}),
  'n:ctrl,cmd': S.op('push', {direction: 'left', style: 'bar-resize:screenSizeX/3'}),

  'y:ctrl,cmd': S.op('corner', {direction: 'bottom-left', width: 'screenSizeX/3', height: 'screenSizeY/2'}),
  'u:ctrl,cmd': S.op('corner', {direction: 'top-left', width: 'screenSizeX/3', height: 'screenSizeY/2'}),
  'i:ctrl,cmd': S.op('corner', {direction: 'top-right', width: 'screenSizeX/3', height: 'screenSizeY/2'}),
  'o:ctrl,cmd': S.op('corner', {direction: 'bottom-right', width: 'screenSizeX/3', height: 'screenSizeY/2'}),

  'g:ctrl,cmd': S.op('grid'),
});

// Test Cases
// S.src(".slate.test", true);
// S.src(".slate.test.js", true);

S.log('[SLATE] ----------- Finished Loading Config -----------');
