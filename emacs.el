;; packages
(setq package-list '(magit nlinum org-ref
                     ob-ipython elfeed auctex
                     reftex doom-themes doom-modeline
                     virtualenvwrapper diff-hl julia-mode
                     julia-repl markdown-mode rainbow-delimiters
                     company company-c-headers elpy))

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.milkbox.net/packages/")
   t))

;; activate packages
(when (< emacs-major-version 27)
  (package-initialize))

;; fetch the list of available packages 
(unless package-archive-contents
  (package-refresh-contents))

;; install packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; add custom packages which are not part of melpa
;; ox-rss
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; configure virtual environment
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)
(setq venv-location "~/Envs/")

;; doom theme setup
(require 'doom-themes)
(setq doom-themes-enable-bold t
    doom-themes-enable-italic t)
(load-theme 'doom-one t)
;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
;; Enable custom neotree theme
(doom-themes-neotree-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;; Doom modeline
(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-height 25)
(setq doom-modeline-bar-width 3)
(setq doom-modeline-icon t)
(setq doom-modeline-env-version t)

;; Highlight current line
(global-hl-line-mode 1)

;; Highlight matching parenthesis on point
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Rainbow delimiters to make life sane, style from Denis Ogbe
(require 'rainbow-delimiters)

(set-face-attribute 'rainbow-delimiters-depth-1-face nil
                    :foreground "#78c5d6")
(set-face-attribute 'rainbow-delimiters-depth-2-face nil
                    :foreground "#bf62a6")
(set-face-attribute 'rainbow-delimiters-depth-3-face nil
                    :foreground "#459ba8")
(set-face-attribute 'rainbow-delimiters-depth-4-face nil
                    :foreground "#e868a2")
(set-face-attribute 'rainbow-delimiters-depth-5-face nil
                    :foreground "#79c267")
(set-face-attribute 'rainbow-delimiters-depth-6-face nil
                    :foreground "#f28c33")
(set-face-attribute 'rainbow-delimiters-depth-7-face nil
                    :foreground "#c5d647")
(set-face-attribute 'rainbow-delimiters-depth-8-face nil
                    :foreground "#f5d63d")
(set-face-attribute 'rainbow-delimiters-depth-9-face nil
                    :foreground "#78c5d6")

;; Unmatching delimiters to stand out more
(set-face-attribute 'rainbow-delimiters-unmatched-face nil
                    :foreground 'unspecified
                    :inherit 'show-paren-mismatch
                    :strike-through t)

;; Hook for lisp
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)

;; Auto insert closing delimiters
(electric-pair-mode 1)

;; configuration for latex work
(setq-default TeX-master nil)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(require 'reftex) ;; cross ref and bib
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ;; reftex with AUCTeX LaTeX mode

;; Company mode completion
(require 'company)
(setq company-tooltip-align-annotations t)
(setq company-selection-wrap-around t)
(setq company-tooltip-flip-when-above t)
(setq company-idle-delay 0.0)
(add-hook 'after-init-hook 'global-company-mode)
(require 'company-dabbrev)
(require 'company-dabbrev-code)
(setq company-dabbrev-code-everywhere t)
(setq company-dabbrev-code-ignore-case nil)
(setq company-dabbrev-ignore-case nil)
(add-to-list 'company-dabbrev-code-modes 'julia-mode)
(add-to-list 'company-dabbrev-code-modes 'matlab-mode)
(add-to-list 'company-dabbrev-code-modes 'matlab-shell-mode)
;; Activate on TAB
(define-key company-active-map [tab] 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
;; Backends
(require 'company-auctex)
(require 'company-math)
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/5.2.0/")

(defvar my-company-backends nil
  "A list of my company backends")
(setq my-company-backends
      '(company-auctex-labels
        company-auctex-bibs
        (company-auctex-macros company-auctex-symbols company-auctex-environments)
        (company-math-symbols-latex company-math-symbols-unicode)
        company-ispell
        (company-semantic
         company-clang company-c-headers)
        ;;company-matlab-shell
        company-bbdb
        company-elisp
        ac-js2-company
        company-nxml
        company-css
        company-eclim
        company-xcode
        company-cmake
        company-capf
        (company-dabbrev-code company-gtags company-etags company-keywords)
        company-oddmuse
        company-files
        company-dabbrev
        company-yasnippet))
(setq company-backends my-company-backends)

;; Python
(elpy-enable)
(setq elpy-rpc-backend "jedi")
(setq elpy-modules
      (quote
       (elpy-module-company
        elpy-module-eldoc
        elpy-module-pyvenv
        elpy-module-yasnippet
        elpy-module-sane-defaults)))

;; configure orgmode
(require 'org)
(setq org-latex-listings 'minted)
(setq org-fontify-whole-heading-line t)
(setq org-src-tab-acts-natively t)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
(setq org-image-actual-width nil)
(setq org-time-clocksum-use-effort-durations t)
;; setup babel languages
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)
			     (ipython . t)
			     (R . t)
			     (shell . t)
			     (calc . t)
			     (emacs-lisp . t)
			     (plantuml . t)
			     (latex . t)
			     (ditaa . t)))

;; Enable julia mode and repl
(require 'julia-mode)
(require 'julia-repl)
(add-hook 'julia-mode-hook 'julia-repl-mode)
(add-hook 'julia-repl-hook #'julia-repl-use-emacsclient)

;; display/update images in the buffer after evaluation
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)

;; line number display
;;(require 'nlinum)

;; set line numbering
(defconst modi/linum-mode-hooks '(verilog-mode-hook
                                  emacs-lisp-mode-hook
                                  cperl-mode-hook
                                  c-mode-hook
                                  python-mode-hook
                                  matlab-mode-hook
                                  sh-mode-hook
                                  web-mode-hook
                                  html-mode-hook
                                  css-mode-hook
                                  makefile-gmake-mode-hook
                                  tcl-mode-hook
				                  org-hook)
  "List of hooks of major modes in which a linum mode should be enabled.")

;; line number configuration
(when global-linum-mode
  (global-nlinum-mode -1))
(dolist (hook modi/linum-mode-hooks)
  (add-hook hook #'nlinum-mode))
(setq nlinum-highlight-current-line t)
(setq nlinum-format " %d ")

;; general settings
(when (display-graphic-p)
  (tool-bar-mode -1))
(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(setq initial-scratch-message nil)
(line-number-mode 1)
(column-number-mode 1)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default fill-column 80)
(menu-bar-mode -1)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(toggle-frame-maximized)

;; Startup buffer
(setq initial-buffer-choice "~/")
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 90))

;; Disable all version control which makes startup and opening files much faster
;; except git
(setq vc-handled-backends '(Git))

;; Python
(setq python-indent-offset 4)

;; make garbage collection less frequent, which speeds up init by about 2 seconds
(setq gc-cons-threshold 80000000)

;; autosave to avoid clutter
(defvar backup-dir (expand-file-name "~/.emacs.d/emacs_backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))
(setq tramp-backup-directory-alist backup-directory-alist)
(setq tramp-auto-save-directory autosave-dir)

;; setup the multi-window jump behaviour
(global-set-key (kbd "C-S-x <C-up>") 'windmove-up)
(global-set-key (kbd "C-S-x <C-down>") 'windmove-down)
(global-set-key (kbd "C-S-x <C-left>") 'windmove-left)
(global-set-key (kbd "C-S-x <C-right>") 'windmove-right)

;; color code some latex code
(add-hook
 'LaTeX-mode-hook
 (lambda ()
   (font-latex-add-keywords '(("citep" "*[[{")) 'reference)
   (font-latex-add-keywords '(("citet" "*[[{")) 'reference)
   (font-latex-add-keywords '(("subfloat" "*[[{")) 'reference)
   (font-latex-add-keywords '(("textwidth" "*[[{")) 'reference)
   (font-latex-add-keywords '(("includegraphics" "*[[{")) 'reference)))

;; org-ref setup
(require 'org-ref)
(setq reftex-default-bibliography '("~/Dropbox/PhD/Academic/Text_docs/Ref/PhD.bib"))
(setq org-ref-default-bibliography '("~/Dropbox/PhD/Academic/Text_docs/Ref/PhD.bib"))

;; pdf compilation
(setq org-latex-pdf-process
      '("pdflatex -interaction nonstopmode -output-directory %o %f"
	"bibtex %b"
	"pdflatex -interaction nonstopmode -output-directory %o %f"
	"pdflatex -interaction nonstopmode -output-directory %o %f"))

(setq line-move-visual nil)

;; setup org-mode specific bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-c(" 'org-agenda-file-to-front)
(global-set-key "\C-c)" 'org-remove-file)

;; setup spell checking with flyspell
(global-set-key "\M-s" 'flyspell-buffer)

;; configure the behaviour when opening links
(setq org-file-apps
      '(("\\.pdf\\'" . system)))

;; configure shell
(global-set-key (kbd "C-x m") 'eshell)

;; configure magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Git gutter
(global-diff-hl-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;; configure elfeed
(require 'elfeed)
(global-set-key (kbd "C-x w") 'elfeed)
;; track feeds
(setq elfeed-feeds
      '("http://planetpython.org/rss20.xml"
	"http://planet.scipy.org/rss20.xml"
        "http://planet.emacsen.org/atom.xml"
	"http://emacs.stackexchange.com/feeds"
	"http://feeds.nature.com/nmat/rss/current"
	"https://www.journals.elsevier.com/engineering-fracture-mechanics/rss/" ;; engineering fracture mechanics journal info
	"https://www.journals.elsevier.com/international-journal-of-heat-and-mass-transfer/rss/" ;; heat and mass transfer journal info
	"http://rss.sciencedirect.com/publication/science/00137944" ;; journal of engineering fracture mechanics articles
	"http://rss.sciencedirect.com/publication/science/00179310" ;; journal of heat and mass transfer articles
	"http://rss.sciencedirect.com/publication/science/18777503" ;; journal of computational science articles
	"http://rss.sciencedirect.com/publication/science/07437315" ;; journal of parallel and distributed computing
	"http://rss.sciencedirect.com/publication/science/00104655" ;; journal of computer physics communications
	"http://rss.sciencedirect.com/publication/science/09205489" ;; journal of computer standards and interfaces
	"http://materialstechnology.asmedigitalcollection.asme.org/rss/site_71/121.xml" ;; journal of engineering materials and technology
	"http://computingengineering.asmedigitalcollection.asme.org/rss/site_66/116.xml" ;; journal of computing and information science in eng
	"http://thermalscienceapplication.asmedigitalcollection.asme.org/rss/site_83/133.xml" ;; journal of thermal science and engineering application
	"http://heattransfer.asmedigitalcollection.asme.org/rss/site_74/124.xml" ;; journal of heat transfer
	"http://rss.sciencedirect.com/publication/science/09215093" ;; materials science and engineering: A (structural materials)
	))
(define-key elfeed-search-mode-map (kbd "r") 'elfeed-search-untag-all-unread)
(push '(relevant relevant-elfeed-entry)
      elfeed-search-face-alist)
(push '(important important-elfeed-entry)
      elfeed-search-face-alist)
;; score and highlight relevant articles
(defun score-elfeed-entry (entry)
  (let ((title (elfeed-entry-title entry))
        (content (elfeed-deref (elfeed-entry-content entry)))
        (score 0))
    (loop for (pattern n) in '(("machine learning\\|neural" 1)
			       ("data mining" 1)
			       ("FEM\\|Finite Element" 1)
			       ("GPU\\|Cuda" 1)
                               ("parallel" 1)
                               ("reproducible" 1)
                               ("Wang" 2)
			       ("fracture" 2)
			       ("cohesive" 2)
			       ("fire" 2)
			       ("LNG" 2))
          if (string-match pattern title)
          do (incf score n)
          if (string-match pattern content)
          do (incf score n))
    (message "%s - %s" title score)

    ;; store score for later in case I ever integrate machine learning
    (setf (elfeed-meta entry :my/score) score)

    (cond
     ((= score 1)
      (elfeed-tag entry 'relevant))
     ((> score 1)
      (elfeed-tag entry 'important)))
    entry))

(add-hook 'elfeed-new-entry-hook 'score-elfeed-entry)

;; custom UUID function
(defun xah-insert-random-uuid ()
"Insert a UUID. This uses a simple hashing of variable data.
Example of a UUID: 1df63142-a513-c850-31a3-535fc3520c3d"
;; by Christopher Wellons, 2011-11-18. Editted by Xah Lee.
;; Edited by Hideki Saito further to generate all valid variants for "N" in xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx format.
  (interactive)
  (let ((myStr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                            (user-uid)
                            (emacs-pid)
                            (system-name)
                            (user-full-name)
                            (current-time)
                            (emacs-uptime)
                            (garbage-collect)
                            (buffer-string)
                            (random)
                            (recent-keys)))))

    (insert (format "%s-%s-4%s-%s%s-%s"
                    (substring myStr 0 8)
                    (substring myStr 8 12)
                    (substring myStr 13 16)
                    (format "%x" (+ 8 (random 4)))
                    (substring myStr 17 20)
                    (substring myStr 20 32)))))

;; Toggle code execution confirmation
(defun babel-confirm (flag)
  "Report the setting of org-confirm-babel-evaluate.
If invoked with C-u, toggle the setting"
  (interactive "P")
  (if (equal flag '(4))
      (setq org-confirm-babel-evaluate (not org-confirm-babel-evaluate)))
  (message "Babel evaluation confirmation is %s"
           (if org-confirm-babel-evaluate "on" "off")))

;; text utilities
(defun words-dictionary ()
  (interactive)
  (browse-url
   (format
    "http://dictionary.reference.com/browse/%s?s=t"
    (thing-at-point 'word))))

(defun words-thesaurus ()
  (interactive)
  (browse-url
   (format
    "http://www.thesaurus.com/browse/%s"
    (thing-at-point 'word))))

(defun words-google ()
  (interactive)  
  (browse-url
   (format
    "http://www.google.com/search?q=%s"
    (if (region-active-p)
        (url-hexify-string (buffer-substring (region-beginning)
                                             (region-end)))
      (thing-at-point 'word)))))

(defun words-duck ()
  (interactive)
  (browse-url
   (format
    "https://duckduckgo.com/?q=%s"
    (if (region-active-p)
        (url-hexify-string (buffer-substring (region-beginning)
                                             (region-end)))
      (thing-at-point 'word)))))

(defvar words-funcs '()
 "functions to run in `words'. Each entry is a list of (key menu-name function).")

(setq words-funcs
  '(("d" "ictionary" words-dictionary)
    ("t" "hesaurus" words-thesaurus)
    ("g" "oogle" words-google)
    ("u" "duck" words-duck)))

(defun words ()
  (interactive)
   (message
   (concat
    (mapconcat
     (lambda (tup)
       (concat "[" (elt tup 0) "]"
               (elt tup 1) " "))
     words-funcs "") ": "))
   (let ((input (read-char-exclusive)))
     (funcall
      (elt 
       (assoc
        (char-to-string input) words-funcs)
       2))))

(defun words-twitter ()
  (interactive)
  (browse-url
   (format
    "https://twitter.com/search?q=%s"
    (if (region-active-p)
        (url-hexify-string (buffer-substring (region-beginning)
                                             (region-end)))
      (thing-at-point 'word)))))

(add-to-list 'words-funcs
  '("w" "twitter" words-twitter)
  t) ; append
(defun words-atd ()
  "Send paragraph at point to After the deadline for spell and grammar checking."
  (interactive)
  
  (let* ((url-request-method "POST")
         (url-request-data (format
                            "key=some-random-text-&data=%s"
                            (url-hexify-string
                             (thing-at-point 'paragraph))))
         (xml  (with-current-buffer
                   (url-retrieve-synchronously
                    "http://service.afterthedeadline.com/checkDocument")
                 (xml-parse-region url-http-end-of-headers (point-max))))
         (results (car xml))
         (errors (xml-get-children results 'error)))
    
    (switch-to-buffer-other-frame "*ATD*")
    (erase-buffer)
    (dolist (err errors)
      (let* ((children (xml-node-children err))
             ;; for some reason I could not get the string out, and had to do this.
             (s (car (last (nth 1 children))))
             ;; the last/car stuff doesn't seem right. there is probably
             ;; a more idiomatic way to get this
             (desc (last (car (xml-get-children children 'description))))
             (type (last (car (xml-get-children children 'type))))
             (suggestions (xml-get-children children 'suggestions))
             (options (xml-get-children (xml-node-name suggestions) 'option))
             (opt-string  (mapconcat
                           (lambda (el)
                             (when (listp el)
                               (car (last el))))
                           options
                           " ")))

        (insert (format "** %s ** %s
Description: %s
Suggestions: %s

" s type desc opt-string))))))

(add-to-list 'words-funcs
  '("s" "spell/grammar" words-atd)
  t) ; append

;; custom css to color export code
(setq org-html-htmlize-output-type 'css)

;; add custom templates
;; blog article
(add-to-list 'org-structure-template-alist
             '("b" "# -*- org-export-babel-evaluate: nil -*-
# -*- org-confirm-babel-evaluate: nil -*-
#+HUGO_BASE_DIR: ../../
#+HUGO_SECTION: posts

#+TITLE: ?

#+AUTHOR: Nikola Stoyanov
#+EMAIL: nikst@posteo.net
#+DATE: 

#+HUGO_TAGS: 
#+HUGO_CATEGORIES: 
#+HUGO_DRAFT: true

#+STARTUP: showeverything
#+STARTUP: showstars
#+STARTUP: inlineimages

* "))
;; for report writing

;; set caption for tables below
(setq org-latex-caption-above nil)

;; report template
(add-to-list 'org-structure-template-alist
	     '("rep" "#+TITLE: ?

#+AUTHOR: Nikola Stoyanov
#+EMAIL: nikst@posteo.net
#+DATE: 

bibliographystyle:unsrt
bibliography:~/Dropbox/PhD/Academic/Text_Docs/Ref/references.bib
"))
;; figure insertion
(add-to-list 'org-structure-template-alist
	     '("fig" "#+LATEX_ATTR: :placement [H]
#+CAPTION: ?
#+NAME: ?
#+ATTR_LATEX: :width ?cm
#+ATTR_ORG: :width ?
#+ATTR_HTML: :width ?px"))
;; ipython
(add-to-list 'org-structure-template-alist
             '("ip" "#+BEGIN_SRC ipython :exports both :async t :results output :session\n?\n#+END_SRC"))
;; python
(add-to-list 'org-structure-template-alist
             '("p" "#+BEGIN_SRC python :results raw drawer\n?\n#+END_SRC"))
;; async ipython
(add-to-list 'org-structure-template-alist
             '("ipf" "#+BEGIN_SRC ipython :session :ipyfile ? :exports both :async t :results raw drawer\n\n#+END_SRC"))
;; emacs-lisp
(add-to-list 'org-structure-template-alist
	     '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))
;; heading drawer
(add-to-list 'org-structure-template-alist
             '("head" ":PROPERTIES:\n:ID: ?\n:END:"))
;; latex equations
(add-to-list 'org-structure-template-alist
	     '("leq" "\\begin{equation}\n?\n\\end{equation}\n"))
;; org template for export to word
(add-to-list 'org-structure-template-alist
	     '("word" "#+PANDOC-CSL: /home/nik/Desktop/Dropbox/PhD/Academic/Text_docs/Ref/elsevier-harvard.csl"))
;; ditaa setup
(add-to-list 'org-structure-template-alist
	     '("ditaa" "#+BEGIN_SRC ditaa :file ? :cmdline -r :exports none\n\n#+END_SRC"))
;; org table
(add-to-list 'org-structure-template-alist
             '("tn" "#+TBLNAME: ?"))
;; table formats
(add-to-list 'org-structure-template-alist
             '("t" "|? |"))
(add-to-list 'org-structure-template-alist
             '("tt" "|? | |"))
(add-to-list 'org-structure-template-alist
             '("ttt" "|? | | |"))
(add-to-list 'org-structure-template-alist
             '("tttt" "|? | | | |"))
(add-to-list 'org-structure-template-alist
             '("ttttt" "|? | | | | |"))
(add-to-list 'org-structure-template-alist
             '("tttttt" "|? | | | | | |"))
(add-to-list 'org-structure-template-alist
	     '("month" "#+BEGIN: clocktable :maxlevel 3: scope subtree\n#+END"))
(add-to-list 'org-structure-template-alist
	     '("week" "#+BEGIN: clocktable :maxlevel 4 :scope subtree
**** Personal Study
**** Family/Friends
**** Sports
**** Exova
**** PhD
**** Outreach
"))
(add-to-list 'org-structure-template-alist
	     '("beamer" "#+TITLE: ?
#+AUTHOR: Nikola Stoyanov
#+EMAIL: nikola.stoyanov@postgrad.manchester.ac.uk
#+DATE: ?
#+DESCRIPTION: 
#+KEYWORDS: 
#+LANGUAGE: en
#+OPTIONS: H:3 num:t toc:t :nil @:t ::t |:t ^:t -:t f:t *:t <:t
#+OPTIONS: TeX:t LaTeX:t skip:nil d:nil todo:t pri:nil tags:not-in-toc
#+INFOJS_OPT: view:nil toc:nil ltoc:t mouse:underline buttons:0 path:https://orgmode.org/org-info.js
#+EXPORT_SELECT_TAGS: export
#+EXPORT_EXCLUDE_TAGS: noexport
#+LINK_UP: 
#+LINK_HOME: 
#+COLUMNS: %45ITEM %10BEAMER_ENV(Env) %10BEAMER_ACT(Act) %4BEAMER_COL(Col) %8BEAMER_OPT(Opt)
#+STARTUP: beamer
#+LATEX_CLASS: beamer
#+LATEX_CLASS_OPTIONS: [presentation]
#+BEAMER_THEME: UniversityOfManchester\n"))

;; structure for report
(add-to-list 'org-latex-classes
           '("book-noparts"
              "\\documentclass{book}"
              ("\\chapter{%s}" . "\\chapter*{%s}")
              ("\\section{%s}" . "\\section*{%s}")
              ("\\subsection{%s}" . "\\subsection*{%s}")
              ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
              ("\\paragraph{%s}" . "\\paragraph*{%s}")
              ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;;;.emacs ends here
