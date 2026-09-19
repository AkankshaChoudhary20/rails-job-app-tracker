# Seed a demo user with a handful of applications across every status so the
# dashboard has something to show immediately after `bin/rails db:seed`.
demo = User.find_or_create_by!(email: "demo@example.com") do |user|
  user.password = "password123"
end

seed_applications = [
  { company: "Acme Corp", role: "Backend Engineer", status: :applied, applied_date: 6.days.ago },
  { company: "Globex", role: "Full-Stack Developer", status: :screening, applied_date: 12.days.ago },
  { company: "Initech", role: "Senior Rails Engineer", status: :interview, applied_date: 20.days.ago },
  { company: "Umbrella Corp", role: "Platform Engineer", status: :offer, applied_date: 30.days.ago },
  { company: "Hooli", role: "Software Engineer II", status: :rejected, applied_date: 45.days.ago },
  { company: "Soylent", role: "Ruby Developer", status: :applied, applied_date: 2.days.ago }
]

seed_applications.each do |attrs|
  demo.applications.find_or_create_by!(company: attrs[:company], role: attrs[:role]) do |application|
    application.status = attrs[:status]
    application.applied_date = attrs[:applied_date]
  end
end

puts "Seeded #{demo.applications.count} applications for #{demo.email} (password: password123)"
