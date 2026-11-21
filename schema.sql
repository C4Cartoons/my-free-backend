-- Enable necessary extensions if needed
create extension if not exists "uuid-ossp";

-- Create projects or episodes table
create table if not exists episodes (
    id uuid default uuid_generate_v4() primary key,
    title text not null,
    status text default 'draft',
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create media assets table for tracking generated videos, images, and audio
create table if not exists media_assets (
    id uuid default uuid_generate_v4() primary key,
    episode_id uuid references episodes(id) on delete cascade,
    asset_type text not null, -- e.g., 'video', 'image', 'voiceover'
    file_path text not null,
    bucket_name text default 'c4cartoons-media',
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create generation tasks table for background worker tracking (Celery/Redis)
create table if not exists generation_tasks (
    id uuid default uuid_generate_v4() primary key,
    task_id text unique not null,
    status text default 'pending',
    progress integer default 0,
    error_message text,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
