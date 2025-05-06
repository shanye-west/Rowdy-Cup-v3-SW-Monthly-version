-- Drop existing tables if they exist
DROP TABLE IF EXISTS "tournament" CASCADE;
DROP TABLE IF EXISTS "scores" CASCADE;
DROP TABLE IF EXISTS "match_participants" CASCADE;
DROP TABLE IF EXISTS "matches" CASCADE;
DROP TABLE IF EXISTS "rounds" CASCADE;
DROP TABLE IF EXISTS "holes" CASCADE;
DROP TABLE IF EXISTS "users" CASCADE;
DROP TABLE IF EXISTS "players" CASCADE;
DROP TABLE IF EXISTS "teams" CASCADE;
DROP TABLE IF EXISTS "courses" CASCADE;

-- Create courses table
CREATE TABLE "courses" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL,
    "location" text,
    "description" text,
    CONSTRAINT "courses_name_unique" UNIQUE("name")
);

-- Create teams table
CREATE TABLE "teams" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL,
    "short_name" text NOT NULL,
    "color_code" text NOT NULL
);

-- Create players table
CREATE TABLE "players" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL,
    "team_id" integer NOT NULL,
    "user_id" integer,
    "wins" integer DEFAULT 0,
    "losses" integer DEFAULT 0,
    "ties" integer DEFAULT 0,
    "status" text,
    CONSTRAINT "players_team_id_fk" FOREIGN KEY ("team_id") REFERENCES "teams"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create users table
CREATE TABLE "users" (
    "id" serial PRIMARY KEY NOT NULL,
    "username" text NOT NULL,
    "passcode" text NOT NULL,
    "is_admin" boolean DEFAULT false NOT NULL,
    "player_id" integer,
    "needs_password_change" boolean DEFAULT true NOT NULL,
    CONSTRAINT "users_username_unique" UNIQUE("username"),
    CONSTRAINT "users_player_id_fk" FOREIGN KEY ("player_id") REFERENCES "players"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create holes table
CREATE TABLE "holes" (
    "id" serial PRIMARY KEY NOT NULL,
    "course_id" integer NOT NULL,
    "number" integer NOT NULL,
    "par" integer NOT NULL,
    CONSTRAINT "holes_course_id_fk" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create rounds table
CREATE TABLE "rounds" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL,
    "match_type" text NOT NULL,
    "date" text NOT NULL,
    "course_name" text NOT NULL,
    "start_time" text NOT NULL,
    "is_complete" boolean DEFAULT false,
    "status" text,
    "aviator_score" numeric,
    "producer_score" numeric,
    "course_id" integer,
    CONSTRAINT "rounds_course_id_fk" FOREIGN KEY ("course_id") REFERENCES "courses"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create matches table
CREATE TABLE "matches" (
    "id" serial PRIMARY KEY NOT NULL,
    "round_id" integer NOT NULL,
    "name" text NOT NULL,
    "status" text NOT NULL,
    "current_hole" integer DEFAULT 1,
    "leading_team" text,
    "lead_amount" integer DEFAULT 0,
    "result" text,
    "locked" boolean DEFAULT false,
    CONSTRAINT "matches_round_id_fk" FOREIGN KEY ("round_id") REFERENCES "rounds"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create match_participants table
CREATE TABLE "match_participants" (
    "id" serial PRIMARY KEY NOT NULL,
    "match_id" integer NOT NULL,
    "user_id" integer NOT NULL,
    "team" text NOT NULL,
    "result" text,
    CONSTRAINT "match_participants_match_id_fk" FOREIGN KEY ("match_id") REFERENCES "matches"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "match_participants_player_id_fk" FOREIGN KEY ("user_id") REFERENCES "players"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create scores table
CREATE TABLE "scores" (
    "id" serial PRIMARY KEY NOT NULL,
    "match_id" integer NOT NULL,
    "hole_number" integer NOT NULL,
    "aviator_score" integer,
    "producer_score" integer,
    "winning_team" text,
    "match_status" text,
    CONSTRAINT "scores_match_id_fk" FOREIGN KEY ("match_id") REFERENCES "matches"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Create tournament table
CREATE TABLE "tournament" (
    "id" serial PRIMARY KEY NOT NULL,
    "name" text NOT NULL,
    "aviator_score" numeric,
    "producer_score" numeric,
    "pending_aviator_score" numeric,
    "pending_producer_score" numeric,
    "year" integer NOT NULL
); 