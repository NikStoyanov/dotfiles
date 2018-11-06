;; packages
(setq package-list '(reftex auto-complete magit nlinum org-ref ob-ipython elfeed))

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.milkbox.net/packages/")
   t))

;; activate packages
(package-initialize)

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

(load-theme 'wombat)

;; configuration for latex work
(require 'reftex) ;; cross ref and bib
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ;; reftex with AUCTeX LaTeX mode

;; add intellisense and linter
(require 'auto-complete)
(setq ac-config-default t)

;; color code in org-mode export
(setq org-latex-listings 'minted)

;; add indentation for tab in org files
(setq org-src-tab-acts-natively t)

;; appearance
(require 'nlinum)           ; line number display

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
(when global-linum-mode
  (global-nlinum-mode -1))

(dolist (hook modi/linum-mode-hooks)
  (add-hook hook #'nlinum-mode))

(setq nlinum-highlight-current-line t)

(when (display-graphic-p)
  (tool-bar-mode -1))

(setq inhibit-startup-screen t)

(tool-bar-mode 0)

(setq initial-scratch-message nil)

(line-number-mode 1)

(column-number-mode 1)

;; tab = 4 spaces
;; replace tab with spaces
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)

;; for inline image resize
(setq org-image-actual-width nil)

;; source code fontification
(setq org-src-fontify-natively t)
;; configure org-mode to highlight headings and source code
(defface org-block-begin-line
  '((t (:foreground "#99968b" :background "#303030" :box (:style released-button))))
    "Face used for the line delimiting the begin of source blocks.")
(defface org-block-end-line
  '((t (:foreground "#99968b" :background "#303030" :box (:style released-button))))
  "Face used for the line delimiting the end of source blocks.")

;; set clock format
(setq org-time-clocksum-use-effort-durations t)

;; answer with y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

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

;; display/update images in the buffer after evaluation
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; color code some latex code
(add-hook
 'LaTeX-mode-hook
 (lambda ()
   (font-latex-add-keywords '(("citep" "*[[{")) 'reference)
   (font-latex-add-keywords '(("citet" "*[[{")) 'reference)
   (font-latex-add-keywords '(("subfloat" "*[[{")) 'reference)
   (font-latex-add-keywords '(("textwidth" "*[[{")) 'reference)
   (font-latex-add-keywords '(("includegraphics" "*[[{")) 'reference)))

;; chage todo and done for visibility
(setq org-todo-keyword-faces
 '(("TODO" . "pink"))
 )
(setq org-todo-keyword-faces
 '(("DONE" . "PaleGreen"))
 )

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


(defvar words-funcs '()
 "functions to run in `words'. Each entry is a list of (key menu-name function).")

(setq words-funcs
  '(("d" "ictionary" words-dictionary)
    ("t" "hesaurus" words-thesaurus)
    ("g" "oogle" words-google)))
 

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

;; blogging configuration
(require 'ox-html)
(require 'ox-rss)

(setq org-export-html-coding-system 'utf-8-unix)
(setq org-html-viewport nil)
(setq my-blog-extra-head
      (concat
       "<link rel='icon' href='img/fav.ico' />
        <link rel='stylesheet' href='template/hyde.css'>
        <link rel='stylesheet' href='template/poole.css'>
        <link rel='stylesheet' href='template/source.css'>
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'>"))

(setq my-blog-header-file "~/git/Personal_Website/header.html")
(defun my-blog-header (arg)
  (with-temp-buffer
    (insert-file-contents my-blog-header-file)
    (buffer-string)))

(setq my-blog-footer
    "")
(defun my-blog-org-export-format-drawer (name content)
  (concat "<div class=\"drawer " (downcase name) "\">\n"
    "<h6>" (capitalize name) "</h6>\n"
    content
    "\n</div>"))

(defun my-blog-get-preview (file)
  "The comments in FILE have to be on their own lines, prefereably before and after paragraphs."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let ((beg (+ 1 (re-search-forward "BEGIN_PREVIEW")))
          (end (progn (re-search-forward "END_PREVIEW")
                      (match-beginning 0))))
      (buffer-substring beg end))))

(defun my-blog-sitemap (project &optional sitemap-filename)
  "Generate the sitemap for my blog."
  (let* ((project-plist (cdr project))
         (dir (file-name-as-directory
               (plist-get project-plist :base-directory)))
         (localdir (file-name-directory dir))
         (exclude-regexp (plist-get project-plist :exclude))
         (files (nreverse
                 (org-publish-get-base-files project exclude-regexp)))
         (sitemap-filename (concat dir (or sitemap-filename "sitemap.org")))
         (sitemap-sans-extension
          (plist-get project-plist :sitemap-sans-extension))
         (visiting (find-buffer-visiting sitemap-filename))
         file sitemap-buffer)
    (with-current-buffer
        (let ((org-inhibit-startup t))
          (setq sitemap-buffer
                (or visiting (find-file sitemap-filename))))
      (erase-buffer)
      ;; loop through all of the files in the project
      (while (setq file (pop files))
        (let ((fn (file-name-nondirectory file))
              (link ;; changed this to fix links. see postprocessor.
               (file-relative-name file (file-name-as-directory
                                         (expand-file-name (concat (file-name-as-directory dir) ".")))))
              (oldlocal localdir))
          (when sitemap-sans-extension
            (setq link (file-name-sans-extension link)))
          ;; sitemap shouldn't list itself
          (unless (equal (file-truename sitemap-filename)
                         (file-truename file))
            (let (;; get the title and date of the current file
                  (title (org-publish-format-file-entry "%t" file project-plist))
                  (date (org-publish-format-file-entry "%d" file project-plist))
                  ;; get the preview section from the current file
                  (preview (my-blog-get-preview file))
                  (regexp "\\(.*\\)\\[\\([^][]+\\)\\]\\(.*\\)"))
              ;; insert a horizontal line before every post, kill the first one
              ;; before saving
              (insert "-----\n")
              (cond ((string-match-p regexp title)
                     (string-match regexp title)
                     ;; insert every post as headline
                     (insert (concat"* " (match-string 1 title)
                                    "[[file:" link "]["
                                    (match-string 2 title)
                                    "]]" (match-string 3 title) "\n")))
                    (t (insert (concat "* [[file:" link "][" title "]]\n"))))
              ;; add properties for `ox-rss.el' here
              (let ((rss-permalink (concat (file-name-sans-extension link) ".html"))
                    (rss-pubdate (format-time-string
                                  (car org-time-stamp-formats)
                                  (org-publish-find-date file))))
                (org-set-property "RSS_PERMALINK" rss-permalink)
                (org-set-property "UBDATE" rss-pubdate))
              ;; insert the date, preview, & read more link
              (insert (concat date "\n\n"))
              (insert preview)
	      (insert "attr_html: ")
	      (insert "\n\n")
              (insert (concat "[[file:" link "][Read More...]]\n"))))))
      ;; kill the first hrule to make this look OK
      (goto-char (point-min))
      (let ((kill-whole-line t)) (kill-line))
      (save-buffer))
    (or visiting (kill-buffer sitemap-buffer))))

(setq my-blog-emacs-config-name "emacsconfig.org")
(setq my-blog-process-emacs-config t)

(defun my-blog-pages-postprocessor (project-plist)
  (message "In the pages postprocessor."))

(defun my-blog-articles-preprocessor (project-plist)
  (message "In the articles preprocessor."))

(defun my-blog-articles-postprocessor (project-plist)
  "Message the sitemap file and move it up one directory.

for this to work, we have already fixed the creation of the
relative link in the sitemap-publish function"
  (let* ((sitemap-fn (concat (file-name-sans-extension (plist-get project-plist :sitemap-filename)) ".html"))
         (sitemap-olddir (plist-get project-plist :publishing-directory))
         (sitemap-newdir (expand-file-name (concat (file-name-as-directory sitemap-olddir) "..")))
         (sitemap-oldfile (expand-file-name sitemap-fn sitemap-olddir))
         (sitemap-newfile (expand-file-name (concat (file-name-as-directory sitemap-newdir) sitemap-fn))))
    (with-temp-buffer
      (goto-char (point-min))
      (insert-file-contents sitemap-oldfile)
      ;; massage the sitemap if wanted

      ;; delete the old file and write the correct one
      (delete-file sitemap-oldfile)
      (write-file sitemap-newfile))))

(setq org-publish-project-alist
      `(("blog"
         :components ("blog-articles", "blog-pages", "blog-rss", "blog-res", "blog-images", "blog-dl"))
        ("blog-articles"
         :base-directory "~/git/Personal_Website/blog/"
         :base-extension "org"
         :publishing-directory "~/git/Personal_Website/www/"
         :publishing-function org-html-publish-to-html
;;         :preparation-function my-blog-articles-preprocessor
         :completion-function my-blog-articles-postprocessor
         :htmlized-source t ;; this enables htmlize, which means that I can use css for code!

         :with-author t
         :with-creator nil
         :with-date t

         :headline-level 4
         :section-numbers nil
         :with-toc nil
         :with-drawers t
         :with-sub-superscript nil ;; important!!

         ;; the following removes extra headers from HTML output -- important!
         :html-link-home "/"
         :html-head nil ;; cleans up anything that would have been in there.
         :html-head-extra ,my-blog-extra-head
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-viewport nil

         :html-format-drawer-function my-blog-org-export-format-drawer
         :html-home/up-format ""
;;         :html-mathjax-options ,my-blog-local-mathjax
;;         :html-mathjax-template "<script type=\"text/javascript\" src=\"%PATH\"></script>"
         :html-footnotes-section "<div id='footnotes'><!--%s-->%s</div>"
         :html-link-up ""
         :html-link-home ""
         :html-preamble my-blog-header
         :html-postamble ,my-blog-footer

         ;; sitemap - list of blog articles
         :auto-sitemap t
         :sitemap-filename "blog.org"
         :sitemap-title "Blog"
         ;; custom sitemap generator function
         :sitemap-function my-blog-sitemap
         :sitemap-sort-files anti-chronologically
         :sitemap-date-format "Published: %a %b %d %Y")
        ("blog-pages"
         :base-directory "~/git/Personal_Website/pages/"
         :base-extension "org"
         :publishing-directory "~/git/Personal_Website/www/"
         :publishing-function org-html-publish-to-html
         ;;:preparation-function my-blog-pages-preprocessor
         ;;:completion-function my-blog-pages-postprocessor
         :htmlized-source t

         :with-author t
         :with-creator nil
         :with-date t

         :headline-level 4
         :section-numbers nil
         :with-toc nil
         :with-drawers t
         :with-sub-superscript nil ;; important!!
         :html-viewport nil ;; hasn't worked yet

         ;; the following removes extra headers from HTML output -- important!
         :html-link-home "/"
         :html-head nil ;; cleans up anything that would have been in there.
         :html-head-extra ,my-blog-extra-head
         :html-head-include-default-style nil
         :html-head-include-scripts nil

         :html-format-drawer-function my-blog-org-export-format-drawer
         :html-home/up-format ""
;;         :html-mathjax-options ,my-blog-local-mathjax
;;         :html-mathjax-template "<script type=\"text/javascript\" src=\"%PATH\"></script>"
         :html-footnotes-section "<div id='footnotes'><!--%s-->%s</div>"
         :html-link-up ""
         :html-link-home ""

         :html-preamble my-blog-header
         :html-postamble ,my-blog-footer)
        ("blog-rss"
         :base-directory "~/git/Personal_Website/blog/"
         :base-extension "org"
         :publishing-directory "~/git/Personal_Website/www/"
         :publishing-function org-rss-publish-to-rss

         :html-link-home "http://niksto.net/"
         :html-link-use-abs-url t

         :title "Nikola Stoyanov"
         :rss-image-url "http://niksto.net/img/feed-icon-28x28.png"
         :section-numbers nil
         :exclude ".*"
         :include ("blog.org")
         :table-of-contents nil)
        ("blog-res"
         :base-directory "~/git/Personal_Website/template/"
         :base-extension ".*"
         :publishing-directory "~/git/Personal_Website/www/template/"
         :publishing-function org-publish-attachment
         ;;:completion-function my-blog-minify-css
	 )
        ("blog-images"
         :base-directory "~/git/Personal_Website/img/"
         :base-extension ".*"
         :publishing-directory "~/git/Personal_Website/www/img/"
         :publishing-function org-publish-attachment
         :recursive t)
        ("blog-doc"
         :base-directory "~/git/Personal_Website/doc/"
         :base-extension ".*"
         :publishing-directory "~/git/Personal_Website/www/doc/"
         :publishing-function org-publish-attachment
         :Recursive t)))

;; custom css to color export code
(setq org-html-htmlize-output-type 'css)

;; add custom templates
;; blog article
(add-to-list 'org-structure-template-alist
             '("b" "#+TITLE: ?
#+AUTHOR: Nikola Stoyanov
#+EMAIL: nikola.stoyanov@postgrad.manchester.ac.uk
#+DATE:
#+STARTUP: showall
#+STARTUP: showstars
#+STARTUP: inlineimages

#+BEGIN_PREVIEW\n\n#+END_PREVIEW\n

#+BEGIN_HTML
<div id='disqus_thread'></div>
<script>
    var disqus_config = function () {
        this.page.url = 'https://niksto.net/xxxxxxxxxxxxxxxxxxxx.html';
        this.page.identifier = 'M-x xah-insert-random-';
        this.page.title = 'Title';
    };
    (function() {
        var d = document, s = d.createElement('script');
        s.src = 'https://niksto-net.disqus.com/embed.js';
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>
    Please enable JavaScript to view the
    <a href='https://disqus.com/?ref_noscript' rel='nofollow'>
        comments powered by Disqus.
    </a>
</noscript>
#+END_HTML"))
;; for report writing

;; set caption for tables below
(setq org-latex-caption-above nil)

;; report template
(add-to-list 'org-structure-template-alist
	     '("rep" "# -*- org-export-babel-evaluate: nil -*-
\\newpage
bibliographystyle:unsrt
bibliography:references.bib
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
