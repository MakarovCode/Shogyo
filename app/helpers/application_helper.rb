module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def bootstrap_icon_for flash_type
    { success: "ok-circle", error: "remove-circle", alert: "warning-sign", notice: "exclamation-sign" }[flash_type] || "question-sign"
  end

  def new_or_edit_path(publication, step, in_need, subject=nil, category_id=nil, subcategory_id=nil)
    if publication.id.nil?
      new_account_publication_path(step: step, in_need: in_need, subject: subject, category_id: category_id, subcategory_id: subcategory_id)
    else
      edit_account_publication_path(publication, step: step, in_need: in_need, subject: subject, category_id: category_id, subcategory_id: subcategory_id)
    end
  end

end
