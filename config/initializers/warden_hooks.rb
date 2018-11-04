# Los hooks son como callbacks
# Divese usa Warden
Warden::Manager.after_set_user do |user, oauth, opts|
	oauth.cookies.signed["user.id"] = user.id
	oauth.cookies.signed["user.expires_at"] = 30.minutes.from_now
end

Warden::Manager.before_logout do |user, oauth, opts|
	oauth.cookies.signed["user.id"] = nil
	oauth.cookies.signed["user.expires_at"] = nil
end