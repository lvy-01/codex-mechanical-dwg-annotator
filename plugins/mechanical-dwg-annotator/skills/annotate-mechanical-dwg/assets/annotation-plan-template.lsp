(vl-load-com)
(defun c:APPLYANNOTATIONS (/ doc)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark doc)
  ;; Create layers and add drawing-specific dimensions here.
  (vla-EndUndoMark doc)
  (vla-Regen doc 1)
  (princ "\nAnnotation plan applied.\n") (princ))
