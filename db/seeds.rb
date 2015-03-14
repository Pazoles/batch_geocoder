User.create!(name:  "Admin User",
             email: "mpazoles@afscme.org",
             password:              "beepbeepbeep",
             password_confirmation: "beepbeepbeep",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)