# Seed data for CreatorPulse
# Creates sample creators and content for development/demo

puts "Seeding database..."

# Clear existing data
Content.destroy_all
Creator.destroy_all

# Create Creators
creators_data = [
  { name: "Sarah Chen", email: "sarah.chen@example.com" },
  { name: "Marcus Rivera", email: "marcus.rivera@example.com" },
  { name: "Aisha Patel", email: "aisha.patel@example.com" },
  { name: "Jake Thompson", email: "jake.thompson@example.com" },
  { name: "Elena Volkov", email: "elena.volkov@example.com" },
  { name: "David Kim", email: "david.kim@example.com" },
  { name: "Olivia Santos", email: "olivia.santos@example.com" }
]

creators = creators_data.map do |data|
  Creator.create!(data)
end

puts "  Created #{creators.size} creators"

# Content templates per provider
content_templates = {
  instagram: [
    { title: "Summer Fashion Lookbook", url: "https://instagram.com/p/Cx1234567" },
    { title: "Morning Routine Reel", url: "https://instagram.com/reel/Cy2345678" },
    { title: "Travel Diary: Tokyo", url: "https://instagram.com/p/Cz3456789" },
    { title: "Healthy Meal Prep Ideas", url: "https://instagram.com/p/Ca4567890" },
    { title: "Sunset Photography Tips", url: "https://instagram.com/p/Cb5678901" },
    { title: "Home Office Makeover", url: "https://instagram.com/reel/Cc6789012" },
    { title: "Weekend Brunch Spots", url: "https://instagram.com/p/Cd7890123" },
    { title: "Skincare Routine 2025", url: "https://instagram.com/reel/Ce8901234" }
  ],
  tiktok: [
    { title: "Dance Challenge #trending", url: "https://tiktok.com/@user/video/7123456789" },
    { title: "Life Hack: Kitchen Edition", url: "https://tiktok.com/@user/video/7234567890" },
    { title: "Get Ready With Me", url: "https://tiktok.com/@user/video/7345678901" },
    { title: "POV: First Day at New Job", url: "https://tiktok.com/@user/video/7456789012" },
    { title: "Outfit Check #OOTD", url: "https://tiktok.com/@user/video/7567890123" },
    { title: "Cooking in 60 Seconds", url: "https://tiktok.com/@user/video/7678901234" },
    { title: "Study With Me Session", url: "https://tiktok.com/@user/video/7789012345" },
    { title: "Room Transformation", url: "https://tiktok.com/@user/video/7890123456" }
  ],
  youtube: [
    { title: "Complete Beginner's Guide to Photography", url: "https://youtube.com/watch?v=abc123def" },
    { title: "A Day in My Life as a Creator", url: "https://youtube.com/watch?v=bcd234efg" },
    { title: "Top 10 Productivity Apps 2025", url: "https://youtube.com/watch?v=cde345fgh" },
    { title: "Building My Dream Studio", url: "https://youtube.com/watch?v=def456ghi" },
    { title: "How I Edit My Videos", url: "https://youtube.com/watch?v=efg567hij" },
    { title: "Q&A: Your Questions Answered", url: "https://youtube.com/watch?v=fgh678ijk" },
    { title: "Monthly Favorites Haul", url: "https://youtube.com/watch?v=ghi789jkl" },
    { title: "Behind the Scenes Vlog", url: "https://youtube.com/watch?v=hij890klm" }
  ]
}

# Distribute content across creators
content_count = 0
providers = content_templates.keys

creators.each_with_index do |creator, i|
  # Each creator gets 3-5 pieces of content
  num_contents = rand(3..5)

  num_contents.times do |j|
    provider = providers[(i + j) % providers.size]
    templates = content_templates[provider]
    template = templates[(i + j) % templates.size]

    Content.create!(
      creator: creator,
      title: template[:title],
      social_media_url: template[:url],
      social_media_provider: provider
    )
    content_count += 1
  end
end

puts "  Created #{content_count} content items"
puts "  Distribution: #{Content.group(:social_media_provider).count.map { |k, v| "#{k}: #{v}" }.join(', ')}"
puts "Done!"
