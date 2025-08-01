
vim.api.nvim_set_hl(0, "WordLabelHighlight", { fg = "#ff5577", bg = "#333333" })

function LabelWordsWithLetters()
  local ns_id = vim.api.nvim_create_namespace("word_labels_alpha")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  -- Déclaration des variables au début de la fonction
  local first_visible = vim.fn.line('w0')
  local last_visible = vim.fn.line('w$')
  local lines = vim.api.nvim_buf_get_lines(bufnr, first_visible - 1, last_visible, false)

  local word_index = 0

  -- Boucle sur les lignes récupérées
  for i, line in ipairs(lines) do
    local search_start = 1
    while true do
      local start_pos, end_pos = line:find("%w+", search_start)
      if not start_pos then break end
      if word_index >= 26 * 26 then return end

      local label_text = string.char(string.byte('a') + math.floor(word_index / 26)) ..
                         string.char(string.byte('a') + (word_index % 26))

      -- Utilisation de `first_visible` qui est bien dans la portée de la fonction
      local row = (first_visible - 1) + (i - 1)
      local col = start_pos - 1
      local label = {{label_text, "WordLabelHighlight"}}

      vim.api.nvim_buf_set_extmark(bufnr, ns_id, row, col, {
        virt_text = label,
        virt_text_pos = 'overlay'
      })
      word_index = word_index + 1
      search_start = end_pos + 1
    end
  end
end

function ClearWordLabels()
  -- CORRECTION : On utilise `create_namespace` qui retourne l'ID existant
  -- si l'espace de noms a déjà été créé. C'est plus compatible.
  local ns_id = vim.api.nvim_create_namespace("word_labels_alpha")
  local bufnr = vim.api.nvim_get_current_buf()

  -- Le reste de la fonction est identique.
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  print("Étiquettes de mots effacées.")
end

function GoToLabel()
  -- 1. Affiche les étiquettes
  LabelWordsWithLetters()

    vim.cmd('redraw') -- Force l'affichage
  -- 2. Demande à l'utilisateur quel label il veut
  local target_label = vim.fn.input("Aller au label : ")


  -- Si l'utilisateur annule (appuie sur Echap), on nettoie et on arrête.
  if target_label == "" then
    ClearWordLabels()
    return
  end

  -- 3. Récupère les positions des étiquettes
  local ns_id = vim.api.nvim_create_namespace("word_labels_alpha")
  local bufnr = vim.api.nvim_get_current_buf()
  local marks = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, {details = true})

  -- 4. Cherche le label correspondant et déplace le curseur
for _, mark in ipairs(marks) do
    -- CORRECTION ICI : Accès par index
    -- mark[4] est la table des détails
    -- mark[4].virt_text est la table du texte virtuel
    if mark[4] and mark[4].virt_text and mark[4].virt_text[1][1] == target_label then
      local row = mark[2] + 1 -- La ligne est à l'index 2
      local col = mark[3]     -- La colonne est à l'index 3
      vim.api.nvim_win_set_cursor(0, {row, col})
      break
    end
  end

  ClearWordLabels()
end

