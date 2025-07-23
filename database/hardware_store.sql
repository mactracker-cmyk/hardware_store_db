
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: TABLE categories; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.categories IS 'Таблица categories содержит информацию о различных категориях товаров.
Поля:
category_id (integer, primary key): Уникальный идентификатор категории.
category_name (character varying(100), not null): Название категории.
Связи:
Таблица categories не содержит внешних ключей, но она используется в таблице products для обозначения категории каждого товара.';


--
-- Name: categories_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_categoryid_seq OWNER TO postgres;

--
-- Name: categories_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_categoryid_seq OWNED BY public.categories.category_id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    user_id integer,
    product_id integer,
    comment_text text NOT NULL,
    rating integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT comments_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: TABLE comments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.comments IS 'Таблица comments содержит информацию о комментариях, оставленных пользователями к товарам.
Поля:
comment_id: Уникальный идентификатор комментария.
user_id: Идентификатор пользователя, оставившего комментарий.
product_id: Идентификатор товара, к которому оставлен комментарий.
comment_text: Текст комментария.
rating: Рейтинг товара.
created_at: Дата и время создания комментария.
Связи:
users (comments_userid_fkey): Один пользователь может оставить много комментариев.
products (comments_productid_fkey): Один товар может иметь много комментариев.';


--
-- Name: comments_commentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_commentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_commentid_seq OWNER TO postgres;

--
-- Name: comments_commentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_commentid_seq OWNED BY public.comments.comment_id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: TABLE order_items; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_items IS 'Таблица order_items содержит информацию о конкретных товарах в заказах.
Поля:
order_item_id: Уникальный идентификатор элемента заказа.
order_id: Идентификатор заказа.
product_id: Идентификатор товара.
quantity: Количество товара.
unit_price: Цена за единицу товара.
Связи:
orders (orderitems_orderid_fkey): Один заказ может содержать много элементов заказов.
products (orderitems_productid_fkey): Один товар может быть в нескольких элементах заказов.';


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    user_id integer,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2) NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: TABLE orders; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.orders IS 'Таблица orders содержит информацию о заказах, сделанных пользователями.
Поля:
order_id: Уникальный идентификатор заказа.
user_id: Идентификатор пользователя, сделавшего заказ.
order_date: Дата и время заказа.
total_amount: Общая сумма заказа.
Связи:
users (orders_userid_fkey): Один пользователь может сделать много заказов.
orderitems (orderitems_orderid_fkey): Один заказ может содержать много элементов заказов.';


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(255) NOT NULL,
    category_id integer,
    seller_id integer,
    price numeric(10,2) NOT NULL,
    brand character varying(100),
    release_date date,
    stock integer DEFAULT 0,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.products IS 'Таблица products содержит информацию о товарах, которые продаются на сайте.
Поля:
productid: Уникальный идентификатор товара.
product_name: Название товара.
category_id: Идентификатор категории товара.
seller_id: Идентификатор продавца товара.
price: Цена товара.
brand: Бренд товара.
release_date: Дата выпуска товара.
stock: Количество товара на складе.
description: Описание товара.
created_at: Дата и время добавления товара.
Связи:
comments (comments_productid_fkey): Один товар может иметь много комментариев.
orderitems (orderitems_productid_fkey): Один товар может быть в нескольких элементах заказов.';


--
-- Name: order_product_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.order_product_info AS
 SELECT o.order_id,
    o.user_id,
    o.order_date,
    o.total_amount,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    ((oi.quantity)::numeric * oi.unit_price) AS total_price
   FROM ((public.orders o
     JOIN public.order_items oi ON ((o.order_id = oi.order_id)))
     JOIN public.products p ON ((oi.product_id = p.product_id)));


ALTER VIEW public.order_product_info OWNER TO postgres;

--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderitems_orderitemid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderitems_orderitemid_seq OWNER TO postgres;

--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderitems_orderitemid_seq OWNED BY public.order_items.order_item_id;


--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO postgres;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.order_id;


--
-- Name: products_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_productid_seq OWNER TO postgres;

--
-- Name: products_productid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_productid_seq OWNED BY public.products.product_id;


--
-- Name: seller_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seller_ratings (
    rating_id integer NOT NULL,
    user_id integer,
    seller_id integer,
    rating integer,
    rating_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT seller_ratings_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.seller_ratings OWNER TO postgres;

--
-- Name: TABLE seller_ratings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.seller_ratings IS 'Таблица seller_ratings содержит информацию об оценках продавцов, оставленных пользователями.
Поля:
rating_id: Уникальный идентификатор оценки.
user_id: Идентификатор пользователя, оставившего оценку.
seller_id: Идентификатор продавца, которому оставлена оценка.
rating: Оценка продавца.
rating_date: Дата и время оставления оценки.
Связи:
users (sellerratings_userid_fkey): Один пользователь может оставить много оценок.
sellers (sellerratings_sellerid_fkey): Один продавец может иметь много оценок от пользователей.';


--
-- Name: sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sellers (
    seller_id integer NOT NULL,
    seller_name character varying(100) NOT NULL,
    average_rating numeric(2,1) DEFAULT 0,
    total_ratings integer DEFAULT 0,
    total_sales integer DEFAULT 0
);


ALTER TABLE public.sellers OWNER TO postgres;

--
-- Name: TABLE sellers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sellers IS 'Таблица sellers содержит информацию о продавцах, которые продают товары на сайте.
Поля:
seller_id: Уникальный идентификатор продавца.
seller_name: Имя продавца.
average_rating: Средний рейтинг продавца.
total_ratings: Общее количество оценок, полученных продавцом.
total_sales: Общее количество продаж, выполненных продавцом.
Связи:
products (products_sellerid_fkey): Один продавец может продавать много товаров.
sellerratings (sellerratings_sellerid_fkey): Один продавец может иметь много оценок от пользователей.';


--
-- Name: seller_average_ratings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.seller_average_ratings AS
 SELECT s.seller_id,
    s.seller_name,
    avg(sr.rating) AS average_rating,
    count(sr.rating) AS total_ratings
   FROM (public.sellers s
     LEFT JOIN public.seller_ratings sr ON ((s.seller_id = sr.seller_id)))
  GROUP BY s.seller_id, s.seller_name;


ALTER VIEW public.seller_average_ratings OWNER TO postgres;

--
-- Name: sellerratings_ratingid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sellerratings_ratingid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sellerratings_ratingid_seq OWNER TO postgres;

--
-- Name: sellerratings_ratingid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sellerratings_ratingid_seq OWNED BY public.seller_ratings.rating_id;


--
-- Name: sellers_sellerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sellers_sellerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sellers_sellerid_seq OWNER TO postgres;

--
-- Name: sellers_sellerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sellers_sellerid_seq OWNED BY public.sellers.seller_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    registration_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Таблица users содержит информацию о зарегистрированных пользователях.
Поля:
user_id: Уникальный идентификатор пользователя.
username: Имя пользователя.
passwordhash: Хэшированный пароль пользователя.
email: Электронная почта пользователя.
registration_date: Дата и время регистрации пользователя.
Связи:
comments (comments_userid_fkey): Один пользователь может оставить много комментариев.
orders (orders_userid_fkey): Один пользователь может сделать много заказов.
sellerratings (sellerratings_userid_fkey): Один пользователь может оставить много оценок продавцам.';


--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.user_id;


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_categoryid_seq'::regclass);


--
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_commentid_seq'::regclass);


--
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.orderitems_orderitemid_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_productid_seq'::regclass);


--
-- Name: seller_ratings rating_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_ratings ALTER COLUMN rating_id SET DEFAULT nextval('public.sellerratings_ratingid_seq'::regclass);


--
-- Name: sellers seller_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers ALTER COLUMN seller_id SET DEFAULT nextval('public.sellers_sellerid_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name) FROM stdin;
1	Ноутбуки
2	Десктопы
3	Компьютерные комплектующие
4	Мониторы
5	Принтеры и сканеры
6	Сетевое оборудование
7	Программное обеспечение
8	Аксессуары для компьютеров
9	Хранение данных
10	Игровая периферия
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (comment_id, user_id, product_id, comment_text, rating, created_at) FROM stdin;
1	1	1	Отличный игровой ноутбук, рекомендую!	5	2024-05-23 15:32:48.912167
2	2	2	Рабочая станция превосходит все ожидания.	4	2024-05-23 15:32:48.912167
3	3	3	Графическая карта замечательная для игр.	5	2024-05-23 15:32:48.912167
4	4	4	4K монитор имеет потрясающее качество изображения.	5	2024-05-23 15:32:48.912167
5	5	5	Лазерный принтер очень быстрый и надежный.	5	2024-05-23 15:32:48.912167
6	6	6	Wi-Fi роутер стабильно работает.	4	2024-05-23 15:32:48.912167
7	7	7	Операционная система легко устанавливается и работает без сбоев.	5	2024-05-23 15:32:48.912167
8	8	8	Игровая мышь очень удобная и точная.	4	2024-05-23 15:32:48.912167
9	9	9	Внешний жесткий диск имеет большую емкость и быструю скорость.	5	2024-05-23 15:32:48.912167
10	10	10	Игровая клавиатура отлично подходит для ночных игр.	5	2024-05-23 15:32:48.912167
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	1	1299.99
2	1	8	1	49.99
3	2	7	1	149.99
4	3	2	1	1599.99
5	4	8	1	49.99
6	5	4	1	399.99
7	6	9	1	89.99
8	7	7	1	149.99
9	8	5	1	299.99
10	9	2	1	1599.99
11	10	10	1	79.99
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, user_id, order_date, total_amount) FROM stdin;
1	1	2024-05-01 10:15:00	1349.98
2	2	2024-05-02 11:30:00	149.98
3	3	2024-05-03 14:00:00	1599.99
4	4	2024-05-04 16:45:00	49.99
5	5	2024-05-05 09:00:00	399.99
6	6	2024-05-06 10:30:00	89.99
7	7	2024-05-07 12:45:00	149.99
8	8	2024-05-08 14:15:00	299.99
9	9	2024-05-09 15:30:00	1599.99
10	10	2024-05-10 16:00:00	79.99
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, category_id, seller_id, price, brand, release_date, stock, description, created_at) FROM stdin;
1	Игровой ноутбук	1	1	1299.99	TechBrand	2023-01-15	50	Высокопроизводительный игровой ноутбук с продвинутой графикой	2024-05-23 15:30:11.978512
2	Рабочая станция	2	2	1599.99	TechBrand	2022-11-10	30	Мощная рабочая станция для профессионалов	2024-05-23 15:30:11.978512
3	Графическая карта	3	3	499.99	TechBrand	2023-03-05	100	Последняя модель графической карты для игр и работы	2024-05-23 15:30:11.978512
4	4K монитор	4	4	399.99	TechBrand	2022-12-20	150	Монитор с разрешением 4K для отличного изображения	2024-05-23 15:30:11.978512
5	Лазерный принтер	5	5	299.99	TechBrand	2023-02-10	70	Высокоскоростной лазерный принтер для офиса	2024-05-23 15:30:11.978512
6	Wi-Fi роутер	6	6	99.99	TechBrand	2023-01-25	60	Быстрый и надежный Wi-Fi роутер	2024-05-23 15:30:11.978512
7	Операционная система	7	7	149.99	TechBrand	2023-03-15	80	Новейшая версия операционной системы	2024-05-23 15:30:11.978512
8	Мышь для игр	8	8	49.99	TechBrand	2022-10-05	20	Эргономичная мышь для игр с высокой точностью	2024-05-23 15:30:11.978512
9	Внешний жесткий диск	9	9	89.99	TechBrand	2023-02-28	25	Внешний жесткий диск на 1 ТБ	2024-05-23 15:30:11.978512
10	Игровая клавиатура	10	10	79.99	TechBrand	2023-04-10	40	Механическая игровая клавиатура с подсветкой	2024-05-23 15:30:11.978512
\.


--
-- Data for Name: seller_ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seller_ratings (rating_id, user_id, seller_id, rating, rating_date) FROM stdin;
1	1	1	5	2024-05-23 15:33:14.451828
2	2	2	4	2024-05-23 15:33:14.451828
3	3	3	5	2024-05-23 15:33:14.451828
4	4	4	5	2024-05-23 15:33:14.451828
5	5	5	5	2024-05-23 15:33:14.451828
6	6	6	4	2024-05-23 15:33:14.451828
7	7	7	5	2024-05-23 15:33:14.451828
8	8	8	4	2024-05-23 15:33:14.451828
9	9	9	5	2024-05-23 15:33:14.451828
10	10	10	5	2024-05-23 15:33:14.451828
\.


--
-- Data for Name: sellers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sellers (seller_id, seller_name, average_rating, total_ratings, total_sales) FROM stdin;
1	Лучшие Ноутбуки	4.5	10	100
2	Компьютерный Мир	4.7	15	50
3	Комплектующие Магазин	4.3	20	200
4	Мониторы Маркет	4.6	12	80
5	Принтеры Центр	4.8	18	60
6	Сетевое Общество	4.4	10	40
7	СофтМаг	4.9	22	90
8	Аксессуары База	4.2	14	30
9	Хранение Данных	4.5	16	45
10	Игровая Переферия	4.6	20	70
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password_hash, email, registration_date) FROM stdin;
1	john_doe	hashed_password1	john@example.com	2024-05-23 15:23:42.013847
2	jane_smith	hashed_password2	jane@example.com	2024-05-23 15:23:42.013847
3	alice_jones	hashed_password3	alice@example.com	2024-05-23 15:23:42.013847
4	bob_brown	hashed_password4	bob@example.com	2024-05-23 15:23:42.013847
5	carol_white	hashed_password5	carol@example.com	2024-05-23 15:23:42.013847
6	david_clark	hashed_password6	david@example.com	2024-05-23 15:23:42.013847
7	eve_adams	hashed_password7	eve@example.com	2024-05-23 15:23:42.013847
8	frank_miller	hashed_password8	frank@example.com	2024-05-23 15:23:42.013847
9	grace_hall	hashed_password9	grace@example.com	2024-05-23 15:23:42.013847
10	hank_wilson	hashed_password10	hank@example.com	2024-05-23 15:23:42.013847
\.


--
-- Name: categories_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_categoryid_seq', 21, true);


--
-- Name: comments_commentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_commentid_seq', 10, true);


--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderitems_orderitemid_seq', 11, true);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 10, true);


--
-- Name: products_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_productid_seq', 40, true);


--
-- Name: sellerratings_ratingid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sellerratings_ratingid_seq', 10, true);


--
-- Name: sellers_sellerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sellers_sellerid_seq', 20, true);


--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 20, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: seller_ratings seller_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_ratings
    ADD CONSTRAINT seller_ratings_pkey PRIMARY KEY (rating_id);


--
-- Name: seller_ratings seller_ratings_user_id_seller_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_ratings
    ADD CONSTRAINT seller_ratings_user_id_seller_id_key UNIQUE (user_id, seller_id);


--
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (seller_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: comments comments_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: comments comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: products products_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);


--
-- Name: seller_ratings seller_ratings_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_ratings
    ADD CONSTRAINT seller_ratings_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);


--
-- Name: seller_ratings seller_ratings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seller_ratings
    ADD CONSTRAINT seller_ratings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);

