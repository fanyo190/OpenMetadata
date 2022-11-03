CREATE TABLE IF NOT EXISTS web_analytic_event (
    id VARCHAR(36) GENERATED ALWAYS AS (json ->> '$.id') NOT NULL,
    name VARCHAR(256) GENERATED ALWAYS AS (json ->> '$.name') NOT NULL,
    fullyQualifiedName VARCHAR(256) GENERATED ALWAYS AS (json ->> '$.fullyQualifiedName') NOT NULL,
    eventType VARCHAR(256) GENERATED ALWAYS AS (json ->> '$.eventType') NOT NULL,
    json JSON NOT NULL,
    updatedAt BIGINT UNSIGNED GENERATED ALWAYS AS (json ->> '$.updatedAt') NOT NULL,
    updatedBy VARCHAR(256) GENERATED ALWAYS AS (json ->> '$.updatedBy') NOT NULL,
    deleted BOOLEAN GENERATED ALWAYS AS (json -> '$.deleted'),
    UNIQUE(name),
    INDEX name_index (name)
);

UPDATE bot_entity
SET json = JSON_INSERT(JSON_REMOVE(json, '$.botType'), '$.provider', 'system');

UPDATE role_entity
SET json = JSON_INSERT(json, '$.provider', 'system')
WHERE name in ('DataConsumer', 'DataSteward');

UPDATE policy_entity
SET json = JSON_INSERT(json, '$.provider', 'system')
WHERE fullyQualifiedName in (json, 'DataConsumerPolicy', 'DataStewardPolicy', 'OrganizationPolicy', 'TeamOnlyPolicy');

UPDATE tag_category
SET json = JSON_INSERT(json, '$.provider', 'system')
WHERE name in ('PersonalData', 'PII', 'Tier');

UPDATE tag
SET json = JSON_INSERT(json, '$.provider', 'system')
WHERE fullyQualifiedName in ('PersonalData.Personal', 'PersonalData.SpecialCategory',
'PII.None', 'PII.NonSensitive', 'PII.Sensitive',
'Tier.Tier1', 'Tier.Tier2', 'Tier.Tier3', 'Tier.Tier4', 'Tier.Tier5');