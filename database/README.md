# Database foundation

## Core entities

- users
- roles
- subscriptions
- payments
- vocabulary_entries
- vocabulary_collections
- collection_items
- learning_sessions
- review_records
- learning_progress
- tutor_sessions
- practice_questions
- practice_attempts
- uploaded_files
- ocr_jobs
- ai_jobs
- ai_usage_records
- content_sources
- marketing_campaigns
- marketing_posts
- budget_records
- audit_logs
- notifications

## Design rules

- clear ownership and access boundaries
- stable identifiers and validated relationships
- consistent timestamps and statuses
- separate raw, OCR, user-corrected, and AI-enhanced artifacts
- source and license tracking for all learning content
- no plaintext passwords
- no unnecessary sensitive data

## Current state

The schema is prepared as a target design and will be implemented incrementally based on the MVP scope.
