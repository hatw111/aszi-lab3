--
-- PostgreSQL database dump
--

\restrict IvYdcpxD0G0oAlej2avc858bkwho94iSjpUzaJcV0Pgs0ixp0NFOO824Wc6TvSl

-- Dumped from database version 18.1 (Debian 18.1-1)
-- Dumped by pg_dump version 18.1 (Debian 18.1-1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: log_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO audit_log(db_user, action, row_id)
  VALUES (current_user, TG_OP, COALESCE(NEW.id, OLD.id));
  RETURN COALESCE(NEW, OLD);
END; $$;


ALTER FUNCTION public.log_change() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_log (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    db_user text,
    prompt text,
    allowed boolean,
    reason text
);


ALTER TABLE public.ai_log OWNER TO postgres;

--
-- Name: ai_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_log_id_seq OWNER TO postgres;

--
-- Name: ai_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_log_id_seq OWNED BY public.ai_log.id;


--
-- Name: ai_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_policy (
    allowed_topics text[],
    forbidden_data text[],
    require_local boolean
);


ALTER TABLE public.ai_policy OWNER TO postgres;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT now(),
    db_user text,
    action text,
    row_id integer
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_id_seq OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: citizens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citizens (
    id integer NOT NULL,
    fio text NOT NULL,
    birth_year integer,
    contact_enc bytea,
    region_id integer,
    CONSTRAINT citizens_birth_year_check CHECK ((birth_year > 1900))
);


ALTER TABLE public.citizens OWNER TO postgres;

--
-- Name: citizens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.citizens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.citizens_id_seq OWNER TO postgres;

--
-- Name: citizens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.citizens_id_seq OWNED BY public.citizens.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    doc jsonb
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requests (
    id integer NOT NULL,
    citizen_id integer,
    operator text NOT NULL,
    region_id integer,
    topic text,
    body text,
    status text DEFAULT 'новое'::text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.requests OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requests_id_seq OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


--
-- Name: ai_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_log ALTER COLUMN id SET DEFAULT nextval('public.ai_log_id_seq'::regclass);


--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: citizens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizens ALTER COLUMN id SET DEFAULT nextval('public.citizens_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- Data for Name: ai_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_log (id, ts, db_user, prompt, allowed, reason) FROM stdin;
1	2026-09-27 13:43:44.906982-04	postgres	Кратко изложи типовое обращение по теме ЖКХ	t	тема разрешена, ПДн отсутствуют
2	2026-09-27 13:43:44.906982-04	postgres	Составь ответ заявителю Иванову И.И. по его жалобе	f	содержит персональные данные — передача внешней модели запрещена
\.


--
-- Data for Name: ai_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_policy (allowed_topics, forbidden_data, require_local) FROM stdin;
{ЖКХ,Транспорт,Благоустройство}	{ПДн,ограниченного_доступа}	t
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, ts, db_user, action, row_id) FROM stdin;
1	2026-09-27 13:40:48.646658-04	postgres	UPDATE	1
\.


--
-- Data for Name: citizens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citizens (id, fio, birth_year, contact_enc, region_id) FROM stdin;
1	Иванов И.И.	1990	\\xc30d04070302a9075f6154fb051b65d2410107cac9a7669fda89aa75a8d10e0930f7fd874159bc808463e0212b85eee812dcb64329572d1bf642450452b73ac1de5c21639062d4fb8e081e0ae3403e9cde11	1
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, doc) FROM stdin;
1	{"тема": "ЖКХ", "срочно": true, "вложения": ["фото1.jpg"]}
2	{"тема": "Транспорт", "маршрут": "№400"}
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, name) FROM stdin;
1	Москва
2	Зеленоград
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requests (id, citizen_id, operator, region_id, topic, body, status, created_at) FROM stdin;
1	1	op_msk	1	ЖКХ	Не вывозят мусор	в работе	2026-09-27 13:24:16.386397-04
\.


--
-- Name: ai_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_log_id_seq', 2, true);


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 1, true);


--
-- Name: citizens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citizens_id_seq', 1, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 2, true);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 2, true);


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requests_id_seq', 1, true);


--
-- Name: ai_log ai_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_log
    ADD CONSTRAINT ai_log_pkey PRIMARY KEY (id);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: citizens citizens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizens
    ADD CONSTRAINT citizens_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: requests trg_requests; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_requests AFTER INSERT OR DELETE OR UPDATE ON public.requests FOR EACH ROW EXECUTE FUNCTION public.log_change();


--
-- Name: citizens citizens_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizens
    ADD CONSTRAINT citizens_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: requests requests_citizen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_citizen_id_fkey FOREIGN KEY (citizen_id) REFERENCES public.citizens(id);


--
-- Name: requests requests_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: requests p_region; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY p_region ON public.requests USING ((region_id = 1));


--
-- Name: requests; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE citizens; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.citizens TO op_msk;


--
-- Name: SEQUENCE citizens_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.citizens_id_seq TO op_msk;


--
-- Name: SEQUENCE documents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.documents_id_seq TO op_msk;


--
-- Name: TABLE regions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.regions TO op_msk;
GRANT SELECT ON TABLE public.regions TO analyst;


--
-- Name: SEQUENCE regions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.regions_id_seq TO op_msk;


--
-- Name: TABLE requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.requests TO op_msk;
GRANT SELECT ON TABLE public.requests TO analyst;


--
-- Name: SEQUENCE requests_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.requests_id_seq TO op_msk;


--
-- PostgreSQL database dump complete
--

\unrestrict IvYdcpxD0G0oAlej2avc858bkwho94iSjpUzaJcV0Pgs0ixp0NFOO824Wc6TvSl

