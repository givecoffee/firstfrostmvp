-- FirstFrost: JSONB metadata column and GIN index
-- Adds flexible metadata column to plants, seeds jagged data,
-- demonstrates ->> and @> operators, creates GIN index.
-- Issue #12: schema/12-jsonb-metadata

-- Add column
ALTER TABLE public.plants
ADD COLUMN metadata JSONB DEFAULT '{}';

-- Hydro plant: Tomato with nutrient and reservoir specs
UPDATE public.plants
SET metadata = '{
  "grow_medium": "coco coir",
  "nutrient_line": "General Hydroponics Flora Series",
  "reservoir_size_gal": 5,
  "ec_target": 1.4,
  "ph_target": 5.9
}'::jsonb
WHERE id = 'bbbbbbbb-0000-0000-0000-000000000001';

-- Outdoor plant: Basil with soil and sun specs
UPDATE public.plants
SET metadata = '{
  "soil_type": "loamy garden mix",
  "amendments": ["compost", "perlite"],
  "sun_exposure": "full sun",
  "watering_schedule": "every 2 days"
}'::jsonb
WHERE id = 'bbbbbbbb-0000-0000-0000-000000000002';

-- Query with ->> (extract as text)
SELECT common_name, metadata->>'grow_medium' AS grow_medium
FROM public.plants
WHERE metadata->>'grow_medium' IS NOT NULL;
-- Result: Tomato, coco coir

-- Query with @> (containment check)
SELECT common_name, metadata->'amendments' AS amendments
FROM public.plants
WHERE metadata @> '{"sun_exposure": "full sun"}';
-- Result: Basil, ["compost", "perlite"]

-- GIN index
CREATE INDEX idx_plants_metadata ON public.plants USING GIN (metadata);

-- Verify
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'plants'
AND indexname = 'idx_plants_metadata';
-- Result: CREATE INDEX idx_plants_metadata ON public.plants USING gin (metadata)