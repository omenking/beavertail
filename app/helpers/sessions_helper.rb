module SessionsHelper
  def session_form_for(&proc)
    form_for :session,
      :url => session_path,
      :method => :post,
      :html => {
        :class => 'session_form'},
      &proc
  end
  
  def session_fields(f)
    partial 'sessions/fields', locals(binding)
  end
end