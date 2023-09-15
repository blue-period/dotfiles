local utils = require('utils')
utils.map('n', '<C-l>', '<cmd>noh<CR>') -- Clear highlights     
utils.map('i', 'jk', '<Esc>')           -- jk to escape
utils.map('n', '<C-j>', '<C-W>j') 
utils.map('n', '<C-k>', '<C-W>k') 
utils.map('n', '<C-h>', '<C-W>h') 
utils.map('n', '<C-l>', '<C-W>l') 
utils.map('n', '<Leader><Leader>', ':noh<CR>') --nvim tre

