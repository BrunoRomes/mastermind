--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    game_key character varying,
    code character varying,
    number_of_players integer DEFAULT 1,
    status integer DEFAULT 0,
    max_turns integer,
    current_turn integer DEFAULT 1,
    allow_repetition boolean DEFAULT false,
    winner character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: guesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE guesses (
    id integer NOT NULL,
    game_id integer,
    player_id integer,
    exact integer DEFAULT 0,
    near integer DEFAULT 0,
    code character varying
);


--
-- Name: guesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE guesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE guesses_id_seq OWNED BY guesses.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    player_key character varying,
    name character varying,
    game_id integer
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY guesses ALTER COLUMN id SET DEFAULT nextval('guesses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY players ALTER COLUMN id SET DEFAULT nextval('players_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: guesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY guesses
    ADD CONSTRAINT guesses_pkey PRIMARY KEY (id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: index_games_on_game_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_game_key ON games USING btree (game_key);


--
-- Name: index_games_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_games_on_status ON games USING btree (status);


--
-- Name: index_guesses_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_guesses_on_game_id ON guesses USING btree (game_id);


--
-- Name: index_guesses_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_guesses_on_player_id ON guesses USING btree (player_id);


--
-- Name: index_players_on_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_players_on_game_id ON players USING btree (game_id);


--
-- Name: index_players_on_player_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_players_on_player_key ON players USING btree (player_key);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160521040040');

INSERT INTO schema_migrations (version) VALUES ('20160521053633');

INSERT INTO schema_migrations (version) VALUES ('20160521122700');

INSERT INTO schema_migrations (version) VALUES ('20160521195513');

