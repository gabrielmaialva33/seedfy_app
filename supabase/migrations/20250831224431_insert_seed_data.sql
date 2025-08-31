-- Insert seed data for crops catalog

INSERT INTO public.crops_catalog (
  name_pt, 
  name_en, 
  scientific_name,
  image_url, 
  row_spacing_m, 
  plant_spacing_m, 
  cycle_days, 
  germination_days,
  yield_per_m2,
  category,
  season
) VALUES
  ('Alface', 'Lettuce', 'Lactuca sativa', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.3, 0.25, 45, 7, 4.0, 'leafy', 'all'),
  ('Tomate', 'Tomato', 'Solanum lycopersicum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f345.svg', 0.8, 0.5, 90, 10, 8.0, 'fruit', 'summer'),
  ('Cenoura', 'Carrot', 'Daucus carota', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f955.svg', 0.2, 0.05, 75, 14, 3.0, 'root', 'all'),
  ('Rúcula', 'Arugula', 'Eruca vesicaria', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.2, 0.15, 30, 5, 2.5, 'leafy', 'all'),
  ('Brócolis', 'Broccoli', 'Brassica oleracea', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f966.svg', 0.5, 0.4, 80, 7, 3.5, 'other', 'fall'),
  ('Couve', 'Kale', 'Brassica oleracea var. acephala', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.4, 0.3, 60, 7, 3.0, 'leafy', 'all'),
  ('Pepino', 'Cucumber', 'Cucumis sativus', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f952.svg', 1.0, 0.3, 65, 7, 6.0, 'fruit', 'summer'),
  ('Pimentão', 'Bell Pepper', 'Capsicum annuum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1fad1.svg', 0.6, 0.4, 85, 14, 5.0, 'fruit', 'summer'),
  ('Manjericão', 'Basil', 'Ocimum basilicum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.3, 0.2, 50, 7, 2.0, 'herb', 'summer'),
  ('Salsa', 'Parsley', 'Petroselinum crispum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.2, 0.1, 40, 21, 1.5, 'herb', 'all'),
  ('Beterraba', 'Beet', 'Beta vulgaris', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.3, 0.1, 60, 10, 3.5, 'root', 'all'),
  ('Espinafre', 'Spinach', 'Spinacia oleracea', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f96c.svg', 0.25, 0.15, 40, 7, 2.0, 'leafy', 'fall'),
  ('Abobrinha', 'Zucchini', 'Cucurbita pepo', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f952.svg', 1.0, 0.8, 60, 7, 5.0, 'fruit', 'summer'),
  ('Rabanete', 'Radish', 'Raphanus sativus', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f957.svg', 0.15, 0.05, 25, 5, 2.0, 'root', 'all'),
  ('Coentro', 'Cilantro', 'Coriandrum sativum', 'https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f33f.svg', 0.2, 0.1, 35, 7, 1.5, 'herb', 'all')
ON CONFLICT DO NOTHING;

-- Comments
COMMENT ON TABLE public.crops_catalog IS 'Seed data for crops catalog - basic vegetables and herbs';