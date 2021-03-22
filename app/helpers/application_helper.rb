module ApplicationHelper
  def full_title(page_title = '')
    base_title = t('logo')
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def pending_reconfirmation?
    resource.pending_reconfirmation? ? resource.unconfirmed_email : resource.email
  end
end
