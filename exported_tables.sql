--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: repositories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repositories (
    id bigint NOT NULL,
    author character varying(255),
    description character varying(1000),
    forks integer,
    forks_count integer,
    language character varying(255),
    name character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    repository_url character varying(255),
    stars integer,
    stars_count integer,
    stars_today integer,
    url character varying(255) NOT NULL
);


ALTER TABLE public.repositories OWNER TO postgres;

--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repositories_id_seq OWNER TO postgres;

--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repositories_id_seq OWNED BY public.repositories.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    completed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    cron_expression character varying(255),
    description character varying(1000),
    error_message character varying(2000),
    name character varying(255) NOT NULL,
    scheduled_at timestamp(6) without time zone,
    status character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT tasks_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'RUNNING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[]))),
    CONSTRAINT tasks_type_check CHECK (((type)::text = ANY ((ARRAY['DAILY_TRENDING'::character varying, 'WEEKLY_TRENDING'::character varying, 'LANGUAGE_TRENDING'::character varying])::text[])))
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: trending_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trending_records (
    id bigint NOT NULL,
    date date NOT NULL,
    rank integer NOT NULL,
    stars_gained integer,
    type character varying(255) NOT NULL,
    repository_id bigint NOT NULL,
    CONSTRAINT trending_records_type_check CHECK (((type)::text = ANY ((ARRAY['DAILY'::character varying, 'WEEKLY'::character varying])::text[])))
);


ALTER TABLE public.trending_records OWNER TO postgres;

--
-- Name: trending_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trending_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trending_records_id_seq OWNER TO postgres;

--
-- Name: trending_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trending_records_id_seq OWNED BY public.trending_records.id;


--
-- Name: repositories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories ALTER COLUMN id SET DEFAULT nextval('public.repositories_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: trending_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trending_records ALTER COLUMN id SET DEFAULT nextval('public.trending_records_id_seq'::regclass);


--
-- Data for Name: repositories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repositories (id, author, description, forks, forks_count, language, name, owner, repository_url, stars, stars_count, stars_today, url) FROM stdin;
2	patchy631	In-depth tutorials on LLMs, RAGs and real-world AI agent applications.	1917	1917	Jupyter Notebook	ai-engineering-hub	patchy631	https://github.com/patchy631/ai-engineering-hub	11199	11199	541	https://github.com/patchy631/ai-engineering-hub
9	cyclotruc	Replace 'hub' with 'ingest' in any github url to get a prompt-friendly extract of a codebase	741	741	Python	gitingest	cyclotruc	https://github.com/cyclotruc/gitingest	9779	9779	252	https://github.com/cyclotruc/gitingest
10	krishnadey30	Contains Company Wise Questions sorted based on Frequency and all time	4971	4971	\N	LeetCode-Questions-CompanyWise	krishnadey30	https://github.com/krishnadey30/LeetCode-Questions-CompanyWise	16599	16599	45	https://github.com/krishnadey30/LeetCode-Questions-CompanyWise
13	donnemartin	A curated list of awesome Amazon Web Services (AWS) libraries, open source repos, guides, blogs, and other resources. Featuring the Fiery Meter of AWSome.	1803	1803	Python	awesome-aws	donnemartin	https://github.com/donnemartin/awesome-aws	13314	13314	36	https://github.com/donnemartin/awesome-aws
11	microsoft	24 Lessons, 12 Weeks, Get Started as a Web Developer	13447	13447	JavaScript	Web-Dev-For-Beginners	microsoft	https://github.com/microsoft/Web-Dev-For-Beginners	88763	88763	61	https://github.com/microsoft/Web-Dev-For-Beginners
19	Flowseal	\N	947	947	Batchfile	zapret-discord-youtube	Flowseal	https://github.com/Flowseal/zapret-discord-youtube	14236	14236	539	https://github.com/Flowseal/zapret-discord-youtube
20	php	🧟 The modern PHP app server	335	335	Go	frankenphp	php	https://github.com/php/frankenphp	9053	9053	921	https://github.com/php/frankenphp
21	FareedKhan-dev	Implementation of all RAG techniques in a simpler way	633	633	Jupyter Notebook	all-rag-techniques	FareedKhan-dev	https://github.com/FareedKhan-dev/all-rag-techniques	5195	5195	1241	https://github.com/FareedKhan-dev/all-rag-techniques
23	pixeltris	\N	539	539	JavaScript	TwitchAdSolutions	pixeltris	https://github.com/pixeltris/TwitchAdSolutions	9372	9372	27	https://github.com/pixeltris/TwitchAdSolutions
22	deepseek-ai	DeepEP: an efficient expert-parallel communication library	816	816	Cuda	DeepEP	deepseek-ai	https://github.com/deepseek-ai/DeepEP	8177	8177	399	https://github.com/deepseek-ai/DeepEP
4	microsoft	We all edit.	377	377	Rust	edit	microsoft	https://github.com/microsoft/edit	8849	8849	207	https://github.com/microsoft/edit
14	n8n-io	Fair-code workflow automation platform with native AI capabilities. Combine visual building with custom code, self-host or cloud, 400+ integrations.	31827	31827	TypeScript	n8n	n8n-io	https://github.com/n8n-io/n8n	110399	110399	482	https://github.com/n8n-io/n8n
18	linshenkx	一款提示词优化器，助力于编写高质量的提示词	937	937	TypeScript	prompt-optimizer	linshenkx	https://github.com/linshenkx/prompt-optimizer	7409	7409	1610	https://github.com/linshenkx/prompt-optimizer
24	SillyTavern	LLM Frontend for Power Users.	3456	3456	JavaScript	SillyTavern	SillyTavern	https://github.com/SillyTavern/SillyTavern	15476	15476	28	https://github.com/SillyTavern/SillyTavern
25	gorhill	uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean.	3532	3532	JavaScript	uBlock	gorhill	https://github.com/gorhill/uBlock	54653	54653	31	https://github.com/gorhill/uBlock
26	MHSanaei	Xray panel supporting multi-protocol multi-user expire day & traffic & IP limit (Vmess & Vless & Trojan & ShadowSocks & Wireguard)	4303	4303	JavaScript	3x-ui	MHSanaei	https://github.com/MHSanaei/3x-ui	20551	20551	30	https://github.com/MHSanaei/3x-ui
27	WhiskeySockets	Lightweight full-featured typescript/javascript WhatsApp Web API	1946	1946	JavaScript	Baileys	WhiskeySockets	https://github.com/WhiskeySockets/Baileys	5870	5870	13	https://github.com/WhiskeySockets/Baileys
28	Asabeneh	30 days of JavaScript programming challenge is a step-by-step guide to learn JavaScript programming language in 30 days. This challenge may take more than 100 days, please just follow your own pace. These videos may help too: https://www.youtube.com/channel/UC7PNRuno1rzYPb1xLa4yktw	10236	10236	JavaScript	30-Days-Of-JavaScript	Asabeneh	https://github.com/Asabeneh/30-Days-Of-JavaScript	44577	44577	48	https://github.com/Asabeneh/30-Days-Of-JavaScript
29	is-a-dev	Grab your own sweet-looking '.is-a.dev' subdomain.	12415	12415	JavaScript	register	is-a-dev	https://github.com/is-a-dev/register	6607	6607	7	https://github.com/is-a-dev/register
3	ManimCommunity	A community-maintained Python framework for creating mathematical animations.	2294	2294	Python	manim	ManimCommunity	https://github.com/ManimCommunity/manim	32632	32632	140	https://github.com/ManimCommunity/manim
12	dail8859	A cross-platform, reimplementation of Notepad++	675	675	C++	NotepadNext	dail8859	https://github.com/dail8859/NotepadNext	11203	11203	173	https://github.com/dail8859/NotepadNext
16	anthropics	A collection of notebooks/recipes showcasing some fun and effective ways of using Claude.	1733	1733	Jupyter Notebook	anthropic-cookbook	anthropics	https://github.com/anthropics/anthropic-cookbook	16658	16658	3376	https://github.com/anthropics/anthropic-cookbook
6	DrKLO	Telegram for Android source	8447	8447	Java	Telegram	DrKLO	https://github.com/DrKLO/Telegram	26374	26374	65	https://github.com/DrKLO/Telegram
8	DataExpert-io	This is a repo with links to everything you'd ever want to learn about data engineering	6400	6400	Jupyter Notebook	data-engineer-handbook	DataExpert-io	https://github.com/DataExpert-io/data-engineer-handbook	33396	33396	330	https://github.com/DataExpert-io/data-engineer-handbook
17	Shubhamsaboo	Collection of awesome LLM apps with AI Agents and RAG using OpenAI, Anthropic, Gemini and opensource models.	5128	5128	Python	awesome-llm-apps	Shubhamsaboo	https://github.com/Shubhamsaboo/awesome-llm-apps	45301	45301	5464	https://github.com/Shubhamsaboo/awesome-llm-apps
15	menloresearch	Jan is an open source alternative to ChatGPT that runs 100% offline on your computer	1906	1906	TypeScript	jan	menloresearch	https://github.com/menloresearch/jan	32755	32755	3249	https://github.com/menloresearch/jan
5	kortix-ai	Suna - Open Source Generalist AI Agent	2296	2296	TypeScript	suna	kortix-ai	https://github.com/kortix-ai/suna	15172	15172	50	https://github.com/kortix-ai/suna
30	sub-store-org	Advanced Subscription Manager for QX, Loon, Surge, Stash, Egern and Shadowrocket!	770	770	JavaScript	Sub-Store	sub-store-org	https://github.com/sub-store-org/Sub-Store	6846	6846	9	https://github.com/sub-store-org/Sub-Store
32	f	This repo includes ChatGPT prompt curation to use ChatGPT and other LLM tools better.	17139	17139	JavaScript	awesome-chatgpt-prompts	f	https://github.com/f/awesome-chatgpt-prompts	129363	129363	53	https://github.com/f/awesome-chatgpt-prompts
33	ryanhanwu	本文原文由知名 Hacker Eric S. Raymond 所撰寫，教你如何正確的提出技術問題並獲得你滿意的答案。	5715	5715	JavaScript	How-To-Ask-Questions-The-Smart-Way	ryanhanwu	https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way	32806	32806	11	https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way
34	academind	React - The Complete Guide Course Resources (Code, Attachments, Slides)	2475	2475	JavaScript	react-complete-guide-course-resources	academind	https://github.com/academind/react-complete-guide-course-resources	3214	3214	4	https://github.com/academind/react-complete-guide-course-resources
35	brave	Brave browser for Android, iOS, Linux, macOS, Windows.	2625	2625	JavaScript	brave-browser	brave	https://github.com/brave/brave-browser	19545	19545	9	https://github.com/brave/brave-browser
36	browserbase	The AI Browser Automation Framework	725	725	TypeScript	stagehand	browserbase	https://github.com/browserbase/stagehand	12680	12680	294	https://github.com/browserbase/stagehand
37	facebookresearch	[CVPR 2025 Best Paper Award] VGGT: Visual Geometry Grounded Transformer	850	850	Python	vggt	facebookresearch	https://github.com/facebookresearch/vggt	8728	8728	956	https://github.com/facebookresearch/vggt
38	ever-co	Ever® Gauzy™ - Open Business Management Platform (ERP/CRM/HRM/ATS/PM) - https://gauzy.co	627	627	TypeScript	ever-gauzy	ever-co	https://github.com/ever-co/ever-gauzy	2914	2914	190	https://github.com/ever-co/ever-gauzy
39	YaLTeR	A scrollable-tiling Wayland compositor.	298	298	Rust	niri	YaLTeR	https://github.com/YaLTeR/niri	9013	9013	523	https://github.com/YaLTeR/niri
52	termux	Termux - a terminal emulator application for Android OS extendible by variety of packages.	4630	4630	Java	termux-app	termux	https://github.com/termux/termux-app	42549	42549	39	https://github.com/termux/termux-app
31	vercel	The React Framework	28637	28637	JavaScript	next.js	vercel	https://github.com/vercel/next.js	132608	132608	31	https://github.com/vercel/next.js
1	rasbt	Implement a ChatGPT-like LLM in PyTorch from scratch, step by step	7569	7569	Jupyter Notebook	LLMs-from-scratch	rasbt	https://github.com/rasbt/LLMs-from-scratch	52464	52464	568	https://github.com/rasbt/LLMs-from-scratch
41	PaperMC	Fork of Paper which adds regionised multithreading to the dedicated server.	539	539	Java	Folia	PaperMC	https://github.com/PaperMC/Folia	3939	3939	3	https://github.com/PaperMC/Folia
43	HMCL-dev	A Minecraft Launcher which is multi-functional, cross-platform and popular	728	728	Java	HMCL	HMCL-dev	https://github.com/HMCL-dev/HMCL	7754	7754	12	https://github.com/HMCL-dev/HMCL
44	LSPosed	LSPosed Framework	3546	3546	Java	LSPosed	LSPosed	https://github.com/LSPosed/LSPosed	20647	20647	12	https://github.com/LSPosed/LSPosed
46	Anuken	The automation tower defense RTS	3137	3137	Java	Mindustry	Anuken	https://github.com/Anuken/Mindustry	24165	24165	7	https://github.com/Anuken/Mindustry
47	JabRef	Graphical Java application for managing BibTeX and BibLaTeX (.bib) databases	2838	2838	Java	jabref	JabRef	https://github.com/JabRef/jabref	3920	3920	0	https://github.com/JabRef/jabref
48	halo-dev	强大易用的开源建站工具。	9956	9956	Java	halo	halo-dev	https://github.com/halo-dev/halo	35880	35880	11	https://github.com/halo-dev/halo
49	hkhcoder	\N	3490	3490	Java	vprofile-project	hkhcoder	https://github.com/hkhcoder/vprofile-project	707	707	5	https://github.com/hkhcoder/vprofile-project
50	GrimAnticheat	Fully async, multithreaded, predictive, open source, 3.01 reach, 1.005 timer, 0.01% speed, 99.99% antikb, "bypassable" 1.8-1.21 minecraft anticheat.	401	401	Java	Grim	GrimAnticheat	https://github.com/GrimAnticheat/Grim	1273	1273	3	https://github.com/GrimAnticheat/Grim
54	ViaVersion	Allows the connection of newer clients to older server versions for Minecraft servers.	283	283	Java	ViaVersion	ViaVersion	https://github.com/ViaVersion/ViaVersion	1363	1363	5	https://github.com/ViaVersion/ViaVersion
55	MeteorDevelopment	Based Minecraft utility mod.	1109	1109	Java	meteor-client	MeteorDevelopment	https://github.com/MeteorDevelopment/meteor-client	2730	2730	9	https://github.com/MeteorDevelopment/meteor-client
56	PlayPro	CoreProtect is a blazing fast data logging and anti-griefing tool for Minecraft servers.	514	514	Java	CoreProtect	PlayPro	https://github.com/PlayPro/CoreProtect	819	819	2	https://github.com/PlayPro/CoreProtect
57	freeok	小说下载器 | 小说下载工具 | 小说下载神器 | 免费小说 | 网络小说 | 免费下载 | 网文下载	278	278	Java	so-novel	freeok	https://github.com/freeok/so-novel	3317	3317	35	https://github.com/freeok/so-novel
58	pixelsdb	An efficient storage and compute engine for both on-prem and cloud-native data analytics.	127	127	Java	pixels	pixelsdb	https://github.com/pixelsdb/pixels	441	441	55	https://github.com/pixelsdb/pixels
53	TeamNewPipe	A libre lightweight streaming front-end for Android.	3216	3216	Java	NewPipe	TeamNewPipe	https://github.com/TeamNewPipe/NewPipe	34141	34141	90	https://github.com/TeamNewPipe/NewPipe
51	adityachandelgit	BookLore is a web app for hosting, managing, and exploring books, with support for PDFs, eBooks, reading progress, metadata, and stats.	39	39	Java	BookLore	adityachandelgit	https://github.com/adityachandelgit/BookLore	1305	1305	272	https://github.com/adityachandelgit/BookLore
45	GeyserMC	A bridge/proxy allowing you to connect to Minecraft: Java Edition servers with Minecraft: Bedrock Edition.	736	736	Java	Geyser	GeyserMC	https://github.com/GeyserMC/Geyser	5078	5078	33	https://github.com/GeyserMC/Geyser
40	elastic	Free and Open Source, Distributed, RESTful Search Engine	25281	25281	Java	elasticsearch	elastic	https://github.com/elastic/elasticsearch	73023	73023	85	https://github.com/elastic/elasticsearch
59	languagetool-org	Style and Grammar Checker for 25+ Languages	1443	1443	Java	languagetool	languagetool-org	https://github.com/languagetool-org/languagetool	13239	13239	17	https://github.com/languagetool-org/languagetool
60	NationalSecurityAgency	Ghidra is a software reverse engineering (SRE) framework	6478	6478	Java	ghidra	NationalSecurityAgency	https://github.com/NationalSecurityAgency/ghidra	57998	57998	26	https://github.com/NationalSecurityAgency/ghidra
61	LawnchairLauncher	No clever tagline needed.	1304	1304	Java	lawnchair	LawnchairLauncher	https://github.com/LawnchairLauncher/lawnchair	10441	10441	9	https://github.com/LawnchairLauncher/lawnchair
62	PojavLauncherTeam	A Minecraft: Java Edition Launcher for Android and iOS based on Boardwalk. This repository contains source code for Android platform.	1520	1520	Java	PojavLauncher	PojavLauncherTeam	https://github.com/PojavLauncherTeam/PojavLauncher	8099	8099	4	https://github.com/PojavLauncherTeam/PojavLauncher
63	iluwatar	Design patterns implemented in Java	27048	27048	Java	java-design-patterns	iluwatar	https://github.com/iluwatar/java-design-patterns	92087	92087	13	https://github.com/iluwatar/java-design-patterns
42	PaperMC	The most widely used, high performance Minecraft server that aims to fix gameplay and mechanics inconsistencies	2549	2549	Java	Paper	PaperMC	https://github.com/PaperMC/Paper	11189	11189	47	https://github.com/PaperMC/Paper
64	jenkinsci	Jenkins automation server	9075	9075	Java	jenkins	jenkinsci	https://github.com/jenkinsci/jenkins	24100	24100	43	https://github.com/jenkinsci/jenkins
65	opensearch-project	🔎 Open source distributed and RESTful search engine.	2266	2266	Java	OpenSearch	opensearch-project	https://github.com/opensearch-project/OpenSearch	10990	10990	61	https://github.com/opensearch-project/OpenSearch
66	kunal-kushwaha	This repository consists of the code samples, assignments, and notes for the Java data structures & algorithms + interview preparation bootcamp of WeMakeDevs.	12081	12081	Java	DSA-Bootcamp-Java	kunal-kushwaha	https://github.com/kunal-kushwaha/DSA-Bootcamp-Java	19365	19365	86	https://github.com/kunal-kushwaha/DSA-Bootcamp-Java
67	zxing	ZXing ("Zebra Crossing") barcode scanning library for Java, Android	9403	9403	Java	zxing	zxing	https://github.com/zxing/zxing	33391	33391	24	https://github.com/zxing/zxing
68	bepass-org	Unofficial warp client for android	567	567	Java	oblivion	bepass-org	https://github.com/bepass-org/oblivion	4194	4194	20	https://github.com/bepass-org/oblivion
69	SeleniumHQ	A browser automation framework and ecosystem.	8478	8478	Java	selenium	SeleniumHQ	https://github.com/SeleniumHQ/selenium	32594	32594	65	https://github.com/SeleniumHQ/selenium
70	yuliskov	Advanced player for set-top boxes and tvs running Android OS	1245	1245	Java	SmartTube	yuliskov	https://github.com/yuliskov/SmartTube	23280	23280	200	https://github.com/yuliskov/SmartTube
71	amitshekhariitbhu	Your Cheat Sheet For Android Interview - Android Interview Questions and Answers	2325	2325	Java	android-interview-questions	amitshekhariitbhu	https://github.com/amitshekhariitbhu/android-interview-questions	11928	11928	20	https://github.com/amitshekhariitbhu/android-interview-questions
72	guardianproject	The Github home of Orbot: Tor on Android (Also available on gitlab!)	379	379	Java	orbot-android	guardianproject	https://github.com/guardianproject/orbot-android	2579	2579	30	https://github.com/guardianproject/orbot-android
73	krahets	《Hello 算法》：动画图解、一键运行的数据结构与算法教程。支持 Python, Java, C++, C, C#, JS, Go, Swift, Rust, Ruby, Kotlin, TS, Dart 代码。简体版和繁体版同步更新，English version in translation	14101	14101	Java	hello-algo	krahets	https://github.com/krahets/hello-algo	113640	113640	289	https://github.com/krahets/hello-algo
74	alibaba	阿里巴巴 MySQL binlog 增量订阅&消费组件	7664	7664	Java	canal	alibaba	https://github.com/alibaba/canal	29161	29161	27	https://github.com/alibaba/canal
75	MisterBooo	Demonstrate all the questions on LeetCode in the form of animation.（用动画的形式呈现解LeetCode题目的思路）	14004	14004	Java	LeetCodeAnimation	MisterBooo	https://github.com/MisterBooo/LeetCodeAnimation	76107	76107	144	https://github.com/MisterBooo/LeetCodeAnimation
76	alibaba	Alibaba Java Diagnostic Tool Arthas/Alibaba Java诊断利器Arthas	7559	7559	Java	arthas	alibaba	https://github.com/alibaba/arthas	36390	36390	38	https://github.com/alibaba/arthas
77	awsdocs	Welcome to the AWS Code Examples Repository. This repo contains code examples used in the AWS documentation, AWS SDK Developer Guides, and more. For more information, see the Readme.md file below.	5781	5781	Java	aws-doc-sdk-examples	awsdocs	https://github.com/awsdocs/aws-doc-sdk-examples	10060	10060	21	https://github.com/awsdocs/aws-doc-sdk-examples
78	alibaba	Agentic AI Framework for Java Developers	826	826	Java	spring-ai-alibaba	alibaba	https://github.com/alibaba/spring-ai-alibaba	4285	4285	209	https://github.com/alibaba/spring-ai-alibaba
79	apache	Apache CloudStack is an opensource Infrastructure as a Service (IaaS) cloud computing platform	1190	1190	Java	cloudstack	apache	https://github.com/apache/cloudstack	2419	2419	16	https://github.com/apache/cloudstack
7	anthropics	Claude Code is an agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster by executing routine tasks, explaining complex code, and handling git workflows - all through natural language commands.	809	809	Shell	claude-code	anthropics	https://github.com/anthropics/claude-code	14278	14278	188	https://github.com/anthropics/claude-code
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, completed_at, created_at, cron_expression, description, error_message, name, scheduled_at, status, type) FROM stdin;
1	2025-06-22 20:35:30.108765	2025-06-22 20:35:29.687829	\N	Manually triggered daily trending task	\N	Manual Daily Trending	2025-06-22 20:35:29.679827	COMPLETED	DAILY_TRENDING
2	2025-06-22 20:35:34.760807	2025-06-22 20:35:33.8563	\N	Automatically triggered weekly trending task	\N	Auto Weekly Trending	2025-06-22 20:35:33.8563	COMPLETED	WEEKLY_TRENDING
3	2025-06-22 20:39:16.927088	2025-06-22 20:39:16.555684	\N	Manually triggered daily trending task	\N	Manual Daily Trending	2025-06-22 20:39:16.555684	COMPLETED	DAILY_TRENDING
4	2025-06-22 20:39:18.602197	2025-06-22 20:39:18.344924	\N	Automatically triggered weekly trending task	\N	Auto Weekly Trending	2025-06-22 20:39:18.344924	COMPLETED	WEEKLY_TRENDING
\.


--
-- Data for Name: trending_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trending_records (id, date, rank, stars_gained, type, repository_id) FROM stdin;
1	2025-06-22	1	568	DAILY	1
2	2025-06-22	2	541	DAILY	2
3	2025-06-22	3	140	DAILY	3
4	2025-06-22	4	207	DAILY	4
5	2025-06-22	5	50	DAILY	5
6	2025-06-22	6	65	DAILY	6
7	2025-06-22	7	188	DAILY	7
8	2025-06-22	8	330	DAILY	8
9	2025-06-22	9	252	DAILY	9
10	2025-06-22	10	45	DAILY	10
11	2025-06-22	11	61	DAILY	11
12	2025-06-22	12	173	DAILY	12
13	2025-06-22	13	36	DAILY	13
14	2025-06-22	14	482	DAILY	14
15	2025-06-22	1	568	DAILY	1
16	2025-06-22	2	541	DAILY	2
17	2025-06-22	3	140	DAILY	3
18	2025-06-22	4	207	DAILY	4
19	2025-06-22	5	50	DAILY	5
20	2025-06-22	6	65	DAILY	6
21	2025-06-22	7	188	DAILY	7
22	2025-06-22	8	330	DAILY	8
23	2025-06-22	9	252	DAILY	9
24	2025-06-22	10	45	DAILY	10
25	2025-06-22	11	61	DAILY	11
26	2025-06-22	12	173	DAILY	12
27	2025-06-22	13	36	DAILY	13
28	2025-06-22	14	482	DAILY	14
29	2025-06-22	1	568	DAILY	1
30	2025-06-22	2	541	DAILY	2
31	2025-06-22	3	140	DAILY	3
32	2025-06-22	4	207	DAILY	4
33	2025-06-22	5	50	DAILY	5
34	2025-06-22	6	65	DAILY	6
35	2025-06-22	7	188	DAILY	7
36	2025-06-22	8	330	DAILY	8
37	2025-06-22	9	252	DAILY	9
38	2025-06-22	10	45	DAILY	10
39	2025-06-22	1	3249	WEEKLY	15
40	2025-06-22	2	3853	WEEKLY	8
41	2025-06-22	3	3376	WEEKLY	16
42	2025-06-22	4	5464	WEEKLY	17
43	2025-06-22	5	1610	WEEKLY	18
44	2025-06-22	6	539	WEEKLY	19
45	2025-06-22	7	921	WEEKLY	20
46	2025-06-22	8	1241	WEEKLY	21
47	2025-06-22	9	1376	WEEKLY	7
48	2025-06-22	10	399	WEEKLY	22
49	2025-06-22	1	568	DAILY	1
50	2025-06-22	2	541	DAILY	2
51	2025-06-22	3	140	DAILY	3
52	2025-06-22	4	207	DAILY	4
53	2025-06-22	5	50	DAILY	5
54	2025-06-22	6	65	DAILY	6
55	2025-06-22	7	188	DAILY	7
56	2025-06-22	8	330	DAILY	8
57	2025-06-22	9	252	DAILY	9
58	2025-06-22	10	45	DAILY	10
59	2025-06-22	11	61	DAILY	11
60	2025-06-22	12	173	DAILY	12
61	2025-06-22	13	36	DAILY	13
62	2025-06-22	14	482	DAILY	14
63	2025-06-22	1	568	DAILY	1
64	2025-06-22	2	541	DAILY	2
65	2025-06-22	3	140	DAILY	3
66	2025-06-22	4	207	DAILY	4
67	2025-06-22	5	50	DAILY	5
68	2025-06-22	6	65	DAILY	6
69	2025-06-22	7	188	DAILY	7
70	2025-06-22	8	330	DAILY	8
71	2025-06-22	9	252	DAILY	9
72	2025-06-22	10	45	DAILY	10
73	2025-06-22	11	61	DAILY	11
74	2025-06-22	12	173	DAILY	12
75	2025-06-22	13	36	DAILY	13
76	2025-06-22	14	482	DAILY	14
77	2025-06-22	1	568	DAILY	1
78	2025-06-22	2	541	DAILY	2
79	2025-06-22	3	140	DAILY	3
80	2025-06-22	4	207	DAILY	4
81	2025-06-22	5	50	DAILY	5
82	2025-06-22	6	65	DAILY	6
83	2025-06-22	7	188	DAILY	7
84	2025-06-22	8	330	DAILY	8
85	2025-06-22	9	252	DAILY	9
86	2025-06-22	1	568	DAILY	1
87	2025-06-22	10	45	DAILY	10
88	2025-06-22	2	541	DAILY	2
89	2025-06-22	11	61	DAILY	11
90	2025-06-22	12	173	DAILY	12
91	2025-06-22	3	140	DAILY	3
92	2025-06-22	13	36	DAILY	13
93	2025-06-22	4	207	DAILY	4
94	2025-06-22	14	482	DAILY	14
95	2025-06-22	5	50	DAILY	5
96	2025-06-22	6	65	DAILY	6
97	2025-06-22	7	188	DAILY	7
98	2025-06-22	8	330	DAILY	8
99	2025-06-22	9	252	DAILY	9
100	2025-06-22	10	45	DAILY	10
101	2025-06-22	11	61	DAILY	11
102	2025-06-22	12	173	DAILY	12
103	2025-06-22	13	36	DAILY	13
104	2025-06-22	14	482	DAILY	14
105	2025-06-22	1	568	DAILY	1
106	2025-06-22	2	541	DAILY	2
107	2025-06-22	3	140	DAILY	3
108	2025-06-22	4	207	DAILY	4
109	2025-06-22	5	50	DAILY	5
110	2025-06-22	6	65	DAILY	6
111	2025-06-22	7	188	DAILY	7
112	2025-06-22	8	330	DAILY	8
113	2025-06-22	9	252	DAILY	9
114	2025-06-22	10	45	DAILY	10
115	2025-06-22	11	61	DAILY	11
116	2025-06-22	12	173	DAILY	12
117	2025-06-22	13	36	DAILY	13
118	2025-06-22	14	482	DAILY	14
119	2025-06-22	1	568	DAILY	1
120	2025-06-22	2	541	DAILY	2
121	2025-06-22	3	140	DAILY	3
122	2025-06-22	4	207	DAILY	4
123	2025-06-22	5	50	DAILY	5
124	2025-06-22	6	65	DAILY	6
125	2025-06-22	7	188	DAILY	7
126	2025-06-22	8	330	DAILY	8
127	2025-06-22	9	252	DAILY	9
128	2025-06-22	10	45	DAILY	10
129	2025-06-22	11	61	DAILY	11
130	2025-06-22	12	173	DAILY	12
131	2025-06-22	13	36	DAILY	13
133	2025-06-22	14	482	DAILY	14
147	2025-06-22	1	568	DAILY	1
148	2025-06-22	2	541	DAILY	2
149	2025-06-22	3	140	DAILY	3
150	2025-06-22	4	207	DAILY	4
151	2025-06-22	5	50	DAILY	5
152	2025-06-22	6	65	DAILY	6
153	2025-06-22	7	188	DAILY	7
154	2025-06-22	8	330	DAILY	8
155	2025-06-22	9	252	DAILY	9
156	2025-06-22	10	45	DAILY	10
157	2025-06-22	11	61	DAILY	11
158	2025-06-22	12	173	DAILY	12
159	2025-06-22	13	36	DAILY	13
160	2025-06-22	14	482	DAILY	14
161	2025-06-22	1	61	DAILY	11
162	2025-06-22	2	27	DAILY	23
163	2025-06-22	3	28	DAILY	24
164	2025-06-22	4	31	DAILY	25
165	2025-06-22	5	30	DAILY	26
166	2025-06-22	6	13	DAILY	27
167	2025-06-22	7	48	DAILY	28
168	2025-06-22	8	7	DAILY	29
169	2025-06-22	9	9	DAILY	30
170	2025-06-22	10	31	DAILY	31
171	2025-06-22	11	53	DAILY	32
172	2025-06-22	12	11	DAILY	33
173	2025-06-22	13	4	DAILY	34
174	2025-06-22	14	9	DAILY	35
175	2025-06-22	1	568	DAILY	1
176	2025-06-22	2	541	DAILY	2
177	2025-06-22	3	140	DAILY	3
178	2025-06-22	4	207	DAILY	4
179	2025-06-22	5	50	DAILY	5
180	2025-06-22	6	65	DAILY	6
181	2025-06-22	7	188	DAILY	7
182	2025-06-22	8	330	DAILY	8
183	2025-06-22	9	252	DAILY	9
184	2025-06-22	10	45	DAILY	10
185	2025-06-22	11	61	DAILY	11
186	2025-06-22	12	173	DAILY	12
187	2025-06-22	13	36	DAILY	13
188	2025-06-22	14	482	DAILY	14
189	2025-06-22	1	568	DAILY	1
190	2025-06-22	2	541	DAILY	2
191	2025-06-22	3	140	DAILY	3
192	2025-06-22	4	207	DAILY	4
193	2025-06-22	5	50	DAILY	5
194	2025-06-22	6	65	DAILY	6
195	2025-06-22	7	188	DAILY	7
196	2025-06-22	8	330	DAILY	8
197	2025-06-22	9	252	DAILY	9
198	2025-06-22	10	45	DAILY	10
199	2025-06-22	11	61	DAILY	11
200	2025-06-22	12	173	DAILY	12
201	2025-06-22	13	36	DAILY	13
202	2025-06-22	14	482	DAILY	14
132	2025-06-22	1	568	DAILY	1
134	2025-06-22	2	541	DAILY	2
135	2025-06-22	3	140	DAILY	3
136	2025-06-22	4	207	DAILY	4
137	2025-06-22	5	50	DAILY	5
138	2025-06-22	6	65	DAILY	6
139	2025-06-22	7	188	DAILY	7
140	2025-06-22	8	330	DAILY	8
141	2025-06-22	9	252	DAILY	9
142	2025-06-22	10	45	DAILY	10
143	2025-06-22	11	61	DAILY	11
144	2025-06-22	12	173	DAILY	12
145	2025-06-22	13	36	DAILY	13
146	2025-06-22	14	482	DAILY	14
203	2025-06-22	1	3249	WEEKLY	15
204	2025-06-22	2	3853	WEEKLY	8
205	2025-06-22	3	3376	WEEKLY	16
206	2025-06-22	4	5464	WEEKLY	17
207	2025-06-22	5	1610	WEEKLY	18
208	2025-06-22	6	539	WEEKLY	19
209	2025-06-22	7	921	WEEKLY	20
210	2025-06-22	8	1241	WEEKLY	21
211	2025-06-22	9	1376	WEEKLY	7
212	2025-06-22	10	399	WEEKLY	22
213	2025-06-22	11	294	WEEKLY	36
214	2025-06-22	12	956	WEEKLY	37
215	2025-06-22	13	190	WEEKLY	38
216	2025-06-22	14	523	WEEKLY	39
217	2025-06-22	1	568	DAILY	1
218	2025-06-22	2	541	DAILY	2
219	2025-06-22	3	140	DAILY	3
220	2025-06-22	4	207	DAILY	4
221	2025-06-22	5	50	DAILY	5
222	2025-06-22	6	65	DAILY	6
223	2025-06-22	7	188	DAILY	7
224	2025-06-22	8	330	DAILY	8
225	2025-06-22	9	252	DAILY	9
226	2025-06-22	10	45	DAILY	10
227	2025-06-22	11	61	DAILY	11
228	2025-06-22	12	173	DAILY	12
229	2025-06-22	13	36	DAILY	13
230	2025-06-22	14	482	DAILY	14
231	2025-06-22	1	61	DAILY	11
232	2025-06-22	2	27	DAILY	23
233	2025-06-22	3	28	DAILY	24
234	2025-06-22	4	31	DAILY	25
235	2025-06-22	5	30	DAILY	26
236	2025-06-22	6	13	DAILY	27
237	2025-06-22	7	48	DAILY	28
238	2025-06-22	8	7	DAILY	29
239	2025-06-22	9	9	DAILY	30
240	2025-06-22	10	31	DAILY	31
241	2025-06-22	11	53	DAILY	32
242	2025-06-22	12	11	DAILY	33
243	2025-06-22	13	4	DAILY	34
244	2025-06-22	14	9	DAILY	35
245	2025-06-22	1	568	DAILY	1
246	2025-06-22	2	541	DAILY	2
247	2025-06-22	3	140	DAILY	3
248	2025-06-22	4	207	DAILY	4
249	2025-06-22	5	50	DAILY	5
250	2025-06-22	6	65	DAILY	6
251	2025-06-22	7	188	DAILY	7
252	2025-06-22	8	330	DAILY	8
253	2025-06-22	9	252	DAILY	9
254	2025-06-22	10	45	DAILY	10
255	2025-06-22	11	61	DAILY	11
256	2025-06-22	12	173	DAILY	12
257	2025-06-22	13	36	DAILY	13
258	2025-06-22	14	482	DAILY	14
259	2025-06-22	1	3249	WEEKLY	15
260	2025-06-22	2	3853	WEEKLY	8
261	2025-06-22	3	3376	WEEKLY	16
262	2025-06-22	4	5464	WEEKLY	17
263	2025-06-22	5	1610	WEEKLY	18
264	2025-06-22	6	539	WEEKLY	19
265	2025-06-22	7	921	WEEKLY	20
266	2025-06-22	8	1241	WEEKLY	21
267	2025-06-22	9	1376	WEEKLY	7
268	2025-06-22	10	399	WEEKLY	22
269	2025-06-22	11	294	WEEKLY	36
270	2025-06-22	12	956	WEEKLY	37
271	2025-06-22	13	190	WEEKLY	38
272	2025-06-22	14	523	WEEKLY	39
273	2025-06-22	1	568	DAILY	1
274	2025-06-22	2	541	DAILY	2
275	2025-06-22	3	140	DAILY	3
276	2025-06-22	4	207	DAILY	4
277	2025-06-22	5	50	DAILY	5
278	2025-06-22	6	65	DAILY	6
279	2025-06-22	7	188	DAILY	7
280	2025-06-22	8	330	DAILY	8
281	2025-06-22	9	252	DAILY	9
282	2025-06-22	10	45	DAILY	10
283	2025-06-22	11	61	DAILY	11
284	2025-06-22	12	173	DAILY	12
285	2025-06-22	13	36	DAILY	13
286	2025-06-22	14	482	DAILY	14
287	2025-06-22	1	568	DAILY	1
288	2025-06-22	2	541	DAILY	2
289	2025-06-22	3	140	DAILY	3
290	2025-06-22	4	207	DAILY	4
291	2025-06-22	5	50	DAILY	5
292	2025-06-22	6	65	DAILY	6
293	2025-06-22	7	188	DAILY	7
294	2025-06-22	8	330	DAILY	8
295	2025-06-22	9	252	DAILY	9
296	2025-06-22	10	45	DAILY	10
297	2025-06-22	1	3249	WEEKLY	15
298	2025-06-22	2	3853	WEEKLY	8
299	2025-06-22	3	3376	WEEKLY	16
300	2025-06-22	4	5464	WEEKLY	17
301	2025-06-22	5	1610	WEEKLY	18
302	2025-06-22	6	539	WEEKLY	19
303	2025-06-22	7	921	WEEKLY	20
304	2025-06-22	8	1241	WEEKLY	21
305	2025-06-22	9	1376	WEEKLY	7
306	2025-06-22	10	399	WEEKLY	22
307	2025-06-22	1	568	DAILY	1
308	2025-06-22	2	541	DAILY	2
309	2025-06-22	3	140	DAILY	3
310	2025-06-22	4	207	DAILY	4
311	2025-06-22	5	50	DAILY	5
312	2025-06-22	6	65	DAILY	6
313	2025-06-22	7	188	DAILY	7
314	2025-06-22	8	330	DAILY	8
315	2025-06-22	9	252	DAILY	9
316	2025-06-22	10	45	DAILY	10
317	2025-06-22	11	61	DAILY	11
318	2025-06-22	12	173	DAILY	12
319	2025-06-22	13	36	DAILY	13
320	2025-06-22	14	482	DAILY	14
321	2025-06-22	1	568	DAILY	1
322	2025-06-22	2	541	DAILY	2
323	2025-06-22	3	140	DAILY	3
324	2025-06-22	4	207	DAILY	4
325	2025-06-22	5	50	DAILY	5
326	2025-06-22	6	65	DAILY	6
327	2025-06-22	7	188	DAILY	7
328	2025-06-22	8	330	DAILY	8
329	2025-06-22	9	252	DAILY	9
330	2025-06-22	10	45	DAILY	10
331	2025-06-22	11	61	DAILY	11
332	2025-06-22	12	173	DAILY	12
333	2025-06-22	13	36	DAILY	13
334	2025-06-22	14	482	DAILY	14
335	2025-06-22	1	61	DAILY	11
336	2025-06-22	2	27	DAILY	23
337	2025-06-22	3	28	DAILY	24
338	2025-06-22	4	31	DAILY	25
339	2025-06-22	5	30	DAILY	26
340	2025-06-22	6	13	DAILY	27
341	2025-06-22	7	48	DAILY	28
342	2025-06-22	8	7	DAILY	29
343	2025-06-22	9	9	DAILY	30
344	2025-06-22	10	31	DAILY	31
345	2025-06-22	11	53	DAILY	32
346	2025-06-22	12	11	DAILY	33
347	2025-06-22	13	4	DAILY	34
348	2025-06-22	14	9	DAILY	35
349	2025-06-22	1	568	DAILY	1
350	2025-06-22	2	541	DAILY	2
351	2025-06-22	3	140	DAILY	3
352	2025-06-22	4	207	DAILY	4
353	2025-06-22	5	50	DAILY	5
354	2025-06-22	6	65	DAILY	6
355	2025-06-22	7	188	DAILY	7
356	2025-06-22	8	330	DAILY	8
357	2025-06-22	9	252	DAILY	9
358	2025-06-22	10	45	DAILY	10
359	2025-06-22	11	61	DAILY	11
360	2025-06-22	12	173	DAILY	12
361	2025-06-22	13	36	DAILY	13
362	2025-06-22	14	482	DAILY	14
363	2025-06-22	1	568	DAILY	1
364	2025-06-22	2	541	DAILY	2
365	2025-06-22	3	140	DAILY	3
366	2025-06-22	4	207	DAILY	4
367	2025-06-22	5	50	DAILY	5
368	2025-06-22	6	65	DAILY	6
369	2025-06-22	7	188	DAILY	7
370	2025-06-22	8	330	DAILY	8
371	2025-06-22	9	252	DAILY	9
372	2025-06-22	10	45	DAILY	10
373	2025-06-22	11	61	DAILY	11
374	2025-06-22	12	173	DAILY	12
375	2025-06-22	13	36	DAILY	13
376	2025-06-22	14	482	DAILY	14
377	2025-06-22	1	568	DAILY	1
378	2025-06-22	2	541	DAILY	2
379	2025-06-22	3	140	DAILY	3
380	2025-06-22	4	207	DAILY	4
381	2025-06-22	5	50	DAILY	5
382	2025-06-22	6	65	DAILY	6
383	2025-06-22	7	188	DAILY	7
384	2025-06-22	8	330	DAILY	8
385	2025-06-22	9	252	DAILY	9
386	2025-06-22	10	45	DAILY	10
387	2025-06-22	11	61	DAILY	11
388	2025-06-22	12	173	DAILY	12
389	2025-06-22	13	36	DAILY	13
390	2025-06-22	14	482	DAILY	14
391	2025-06-22	1	65	DAILY	6
392	2025-06-22	2	13	DAILY	40
393	2025-06-22	3	3	DAILY	41
394	2025-06-22	4	9	DAILY	42
395	2025-06-22	5	12	DAILY	43
396	2025-06-22	6	12	DAILY	44
397	2025-06-22	7	8	DAILY	45
398	2025-06-22	8	7	DAILY	46
399	2025-06-22	9	0	DAILY	47
400	2025-06-22	10	11	DAILY	48
401	2025-06-22	11	5	DAILY	49
402	2025-06-22	12	3	DAILY	50
403	2025-06-22	13	103	DAILY	51
404	2025-06-22	14	39	DAILY	52
405	2025-06-22	15	14	DAILY	53
406	2025-06-22	16	5	DAILY	54
407	2025-06-22	17	9	DAILY	55
408	2025-06-22	18	2	DAILY	56
409	2025-06-22	19	35	DAILY	57
410	2025-06-22	20	55	DAILY	58
411	2025-06-22	21	17	DAILY	59
412	2025-06-22	22	26	DAILY	60
413	2025-06-22	23	9	DAILY	61
414	2025-06-22	24	4	DAILY	62
415	2025-06-22	25	13	DAILY	63
416	2025-06-22	1	568	DAILY	1
417	2025-06-22	2	541	DAILY	2
418	2025-06-22	3	140	DAILY	3
419	2025-06-22	4	207	DAILY	4
420	2025-06-22	5	50	DAILY	5
421	2025-06-22	6	65	DAILY	6
422	2025-06-22	7	188	DAILY	7
423	2025-06-22	8	330	DAILY	8
424	2025-06-22	9	252	DAILY	9
425	2025-06-22	10	45	DAILY	10
426	2025-06-22	11	61	DAILY	11
427	2025-06-22	12	173	DAILY	12
428	2025-06-22	13	36	DAILY	13
429	2025-06-22	14	482	DAILY	14
430	2025-06-22	1	102	WEEKLY	6
431	2025-06-22	2	47	WEEKLY	42
432	2025-06-22	3	43	WEEKLY	64
433	2025-06-22	4	61	WEEKLY	65
434	2025-06-22	5	90	WEEKLY	53
435	2025-06-22	6	86	WEEKLY	66
436	2025-06-22	7	24	WEEKLY	67
437	2025-06-22	8	272	WEEKLY	51
438	2025-06-22	9	33	WEEKLY	45
439	2025-06-22	10	20	WEEKLY	68
440	2025-06-22	11	65	WEEKLY	69
441	2025-06-22	12	200	WEEKLY	70
442	2025-06-22	13	85	WEEKLY	40
443	2025-06-22	14	20	WEEKLY	71
444	2025-06-22	15	30	WEEKLY	72
445	2025-06-22	16	289	WEEKLY	73
446	2025-06-22	17	27	WEEKLY	74
447	2025-06-22	18	144	WEEKLY	75
448	2025-06-22	19	38	WEEKLY	76
449	2025-06-22	20	21	WEEKLY	77
450	2025-06-22	21	209	WEEKLY	78
451	2025-06-22	22	16	WEEKLY	79
452	2025-06-22	1	102	WEEKLY	6
453	2025-06-22	2	47	WEEKLY	42
454	2025-06-22	3	43	WEEKLY	64
455	2025-06-22	4	61	WEEKLY	65
456	2025-06-22	5	90	WEEKLY	53
457	2025-06-22	6	86	WEEKLY	66
458	2025-06-22	7	24	WEEKLY	67
459	2025-06-22	8	272	WEEKLY	51
460	2025-06-22	9	33	WEEKLY	45
461	2025-06-22	10	20	WEEKLY	68
462	2025-06-22	11	65	WEEKLY	69
463	2025-06-22	12	200	WEEKLY	70
464	2025-06-22	13	85	WEEKLY	40
465	2025-06-22	14	20	WEEKLY	71
466	2025-06-22	15	30	WEEKLY	72
467	2025-06-22	16	289	WEEKLY	73
468	2025-06-22	17	27	WEEKLY	74
469	2025-06-22	18	144	WEEKLY	75
470	2025-06-22	19	38	WEEKLY	76
471	2025-06-22	20	21	WEEKLY	77
472	2025-06-22	21	209	WEEKLY	78
473	2025-06-22	22	16	WEEKLY	79
474	2025-06-22	1	3249	WEEKLY	15
475	2025-06-22	2	3853	WEEKLY	8
476	2025-06-22	3	3376	WEEKLY	16
477	2025-06-22	4	5464	WEEKLY	17
478	2025-06-22	5	1610	WEEKLY	18
479	2025-06-22	6	539	WEEKLY	19
480	2025-06-22	7	921	WEEKLY	20
481	2025-06-22	8	1241	WEEKLY	21
482	2025-06-22	9	1376	WEEKLY	7
483	2025-06-22	10	399	WEEKLY	22
484	2025-06-22	11	294	WEEKLY	36
485	2025-06-22	12	956	WEEKLY	37
486	2025-06-22	13	190	WEEKLY	38
487	2025-06-22	14	523	WEEKLY	39
488	2025-06-22	1	568	DAILY	1
489	2025-06-22	2	541	DAILY	2
490	2025-06-22	3	140	DAILY	3
491	2025-06-22	4	207	DAILY	4
492	2025-06-22	5	50	DAILY	5
493	2025-06-22	6	65	DAILY	6
494	2025-06-22	7	188	DAILY	7
495	2025-06-22	8	330	DAILY	8
496	2025-06-22	9	252	DAILY	9
497	2025-06-22	10	45	DAILY	10
498	2025-06-22	11	61	DAILY	11
499	2025-06-22	12	173	DAILY	12
500	2025-06-22	13	36	DAILY	13
501	2025-06-22	14	482	DAILY	14
502	2025-06-22	1	568	DAILY	1
503	2025-06-22	2	541	DAILY	2
504	2025-06-22	3	140	DAILY	3
505	2025-06-22	4	207	DAILY	4
506	2025-06-22	5	50	DAILY	5
507	2025-06-22	6	65	DAILY	6
508	2025-06-22	7	188	DAILY	7
509	2025-06-22	8	330	DAILY	8
510	2025-06-22	9	252	DAILY	9
511	2025-06-22	10	45	DAILY	10
512	2025-06-22	11	61	DAILY	11
513	2025-06-22	12	173	DAILY	12
514	2025-06-22	13	36	DAILY	13
515	2025-06-22	14	482	DAILY	14
516	2025-06-22	1	568	DAILY	1
517	2025-06-22	2	541	DAILY	2
518	2025-06-22	3	140	DAILY	3
519	2025-06-22	4	207	DAILY	4
520	2025-06-22	5	50	DAILY	5
521	2025-06-22	6	65	DAILY	6
522	2025-06-22	7	188	DAILY	7
523	2025-06-22	8	330	DAILY	8
524	2025-06-22	9	252	DAILY	9
525	2025-06-22	10	45	DAILY	10
526	2025-06-22	11	61	DAILY	11
527	2025-06-22	12	173	DAILY	12
528	2025-06-22	13	36	DAILY	13
529	2025-06-22	14	482	DAILY	14
530	2025-06-22	1	568	DAILY	1
531	2025-06-22	2	541	DAILY	2
532	2025-06-22	3	140	DAILY	3
533	2025-06-22	4	207	DAILY	4
534	2025-06-22	5	50	DAILY	5
535	2025-06-22	6	65	DAILY	6
536	2025-06-22	7	188	DAILY	7
537	2025-06-22	8	330	DAILY	8
538	2025-06-22	9	252	DAILY	9
539	2025-06-22	10	45	DAILY	10
540	2025-06-22	11	61	DAILY	11
541	2025-06-22	12	173	DAILY	12
542	2025-06-22	13	36	DAILY	13
543	2025-06-22	14	482	DAILY	14
\.


--
-- Name: repositories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repositories_id_seq', 79, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 4, true);


--
-- Name: trending_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trending_records_id_seq', 543, true);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: trending_records trending_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trending_records
    ADD CONSTRAINT trending_records_pkey PRIMARY KEY (id);


--
-- Name: trending_records fkloyti8rnvmwl475qupj25777u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trending_records
    ADD CONSTRAINT fkloyti8rnvmwl475qupj25777u FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- PostgreSQL database dump complete
--

