class OrderMailer < ApplicationMailer
  def confirmation_order(order, user)
    @order = order
    @user = user
    mail to: user.email, subject: t('mailer.subject_confirm_order')
  end
end
