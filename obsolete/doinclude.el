;;; -*- Mode: Emacs-Lisp -*-
;;; doinclude.el
;;; expand files according to the specification "include"

(defvar di:verbose t)

(defun doinclude-and-save ()
  "It does do the inclusion for the current buffer, then it is saved."
  (interactive)
  (doinclude)
  (di:save-as-bibfile))

(defun doinclude ()
  "expand current buffer according to the specification \"include\"."
  (interactive)
  (if di:verbose
      (message (format "Processing %s..." (buffer-name))))
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((include-file (di:find-include-spec)))
	(while include-file
	  (if di:verbose (message (format "Including %s..." include-file)))
	  (di:delete-included-text-if include-file)
	  (di:import-target include-file)
	  (setq include-file (di:find-include-spec))))
      (if di:verbose
	  (message (format "Processed %s." (buffer-name)))))))

(defun di:find-include-spec ()
  "A line having a pattern of

% include: <filename>

is searched, and the filename is returned, if found.  If no such lines 
are found, nil is returned.  After the return of this function, the 
cursor position is at the next line of the include line."
  (interactive)
  (if (re-search-forward "^%+[ \t]*include:[ \t]*\\([^ \t\n]+\\)" nil t)
      (progn
	(forward-line 1) 
	(beginning-of-line)
	(buffer-substring (match-beginning 1) (match-end 1)))))

(defun di:delete-included-text-if (filename)
  "Included text, which is bounded by

% include: <filename>

and

% end of inclusion: <filename>

is searched and deleted.  If there is no such a text, it does nothing."
  (let ((p (point)))
    (if (re-search-forward (format "^%% end of inclusion: %s$" filename)
			   nil t)
	(progn
	  (forward-line 1)
	  (beginning-of-line)
	  (delete-region p (point))))))

(defun di:import-target (filename)
  "The contents of specified file is inserted at the current position.  
After the inserted contents, a pattern

% end of inclusion: <filename>

is written."
  (let ((result (insert-file-contents filename)))
    (goto-char (+ (point) (car (cdr result)))))
  (insert (format "\n%% end of inclusion: %s\n" filename)))

(defun di:get-bibfile-name (filename)
  "Return a filename ended with \".bib\" from a given filename."
  (if (string-match "^\\(.*\\)\\.\\([^./]*\\)$" filename)
      (concat (substring filename
			     (match-beginning 1)(match-end 1))
		  ".bib")
      (concat filename ".bib")))

(defun di:save-as-bibfile ()
  "Current buffer is saved as a .bib file.  If the filename for the
current buffer is also *.bib, it is overwritten."
  (write-file (di:get-bibfile-name (buffer-file-name))))