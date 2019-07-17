;;; cljr-ivy.el --- Wraps clojure refactor commands with ivy -*- coding: utf-8-unix; lexical-binding: t; -*-

;; Copyright (C) 2019 Daniel Berg

;; Author   : Daniel Berg <mail@roosta.sh>
;; URL      : https://github.com/roosta/cljr-ivy
;; Version  : 0.1
;; Keywords : lisp, tools, convinience
;; Package-Requires: ((emacs "24") (clj-refactor "2.4.0") (ivy "0.11.0") (cl-lib "0.6.1"))

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Ivy wrapper for the cljr features.

;; This is a fork of cljr-helm.  Props goes to that repo, I just
;; adapted it to ivy.

;; Remembering key bindings for cljr is hard, especially the less
;; frequently used ones - this should help with that.

;; Add `(require 'cljr-helm)` to your init file, bind `cljr-ivy` to
;; a key (I'd suggest `C-c C-r`) in Clojure mode, and you're ready to go.

;;; Code:

(require 'ivy)
(require 'clj-refactor)

(defun cljr-ivy-candidates ()
  "Get all cljr candidates."
  (mapcar (lambda (c)
            (concat (car c) ": " (cl-second (cdr c))))
          cljr--all-helpers))


;; ;;;###autoload
(defun cljr-ivy ()
  "Call `ivy-read' over cljr candidates, and call chosen function."
  (interactive)
  (ivy-read "CLJR function: "
            (cljr-ivy-candidates)
            :require-match t
            :preselect (ivy-thing-at-point)
            :history 'cljr-ivy-history
            :sort t
            :action (lambda (candidate)
                      (string-match "^\\(.+?\\): " candidate)
                      (call-interactively
                       (cadr (assoc (match-string 1 candidate) cljr--all-helpers))))
            :caller 'cljr-ivy))

(provide 'cljr-ivy)

;;; cljr-ivy.el ends here
