--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

-- Started on 2024-11-12 14:40:03 UTC

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

--
-- TOC entry 1237 (class 1247 OID 26205)
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO postgres;

--
-- TOC entry 1231 (class 1247 OID 26184)
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO postgres;

--
-- TOC entry 1177 (class 1247 OID 25850)
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- TOC entry 1246 (class 1247 OID 26255)
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 266 (class 1259 OID 25572)
-- Name: api_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.api_key OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 25251)
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 25244)
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 26283)
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 25759)
-- Name: capture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 25400)
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 25415)
-- Name: cart_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 25424)
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 25450)
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 25462)
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 26592)
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 26605)
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.cart_promotion OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 25473)
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 25486)
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 25497)
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 25682)
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 25327)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 25337)
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 25351)
-- Name: customer_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25361)
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text
);


ALTER TABLE public.customer_group_customer OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 26445)
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 26335)
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 26471)
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 26460)
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 26345)
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment_provider OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 26353)
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 26376)
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24777)
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.image OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24623)
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24635)
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 26310)
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- TOC entry 329 (class 1259 OID 26580)
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 26579)
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 328
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- TOC entry 332 (class 1259 OID 26618)
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 26631)
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24578)
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24577)
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 215
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- TOC entry 327 (class 1259 OID 26556)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 26548)
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 25837)
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 25826)
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 26644)
-- Name: order_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_cart OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 25889)
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 25904)
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO postgres;

--
-- TOC entry 288 (class 1259 OID 25903)
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 288
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- TOC entry 307 (class 1259 OID 26190)
-- Name: order_claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 26189)
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 306
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- TOC entry 308 (class 1259 OID 26213)
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 26226)
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 25836)
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 284
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- TOC entry 304 (class 1259 OID 26156)
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 26155)
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 303
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- TOC entry 305 (class 1259 OID 26171)
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 26657)
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 25918)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 25942)
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 25966)
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_adjustment OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 25956)
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 26665)
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO postgres;

--
-- TOC entry 337 (class 1259 OID 26666)
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_promotion OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 25930)
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 25976)
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 25987)
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 25997)
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 25878)
-- Name: order_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 26007)
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 25741)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    cart_id text,
    order_id text,
    customer_id text,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 25695)
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    region_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_collection OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 25723)
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 25706)
-- Name: payment_method_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method_token (
    id text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    name text NOT NULL,
    type_detail text,
    description_detail text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_method_token OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 25715)
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.payment_provider OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 25730)
-- Name: payment_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 24975)
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity numeric,
    max_quantity numeric
);


ALTER TABLE public.price OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 25051)
-- Name: price_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0 NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 25061)
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 25156)
-- Name: price_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 25006)
-- Name: price_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_rule OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24966)
-- Name: price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24721)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 24821)
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24851)
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24810)
-- Name: product_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 24844)
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    product_id text NOT NULL,
    image_id text NOT NULL
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24755)
-- Name: product_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24766)
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 26710)
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24788)
-- Name: product_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24837)
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24799)
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24737)
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight numeric,
    length numeric,
    height numeric,
    width numeric,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- TOC entry 339 (class 1259 OID 26687)
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 24858)
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 26695)
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 25193)
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 25208)
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb NOT NULL,
    max_quantity numeric,
    apply_to_quantity numeric,
    buy_rules_min_quantity numeric,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 25168)
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 25179)
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 25237)
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 25225)
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 25258)
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 26292)
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.provider_identity OWNER TO postgres;

--
-- TOC entry 341 (class 1259 OID 26703)
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 25750)
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 25809)
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 25546)
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 25557)
-- Name: region_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 26738)
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24650)
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 26126)
-- Name: return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 26125)
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO postgres;

--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 300
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- TOC entry 338 (class 1259 OID 26678)
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 26141)
-- Name: return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 26020)
-- Name: return_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 25389)
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO postgres;

--
-- TOC entry 343 (class 1259 OID 26724)
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 26364)
-- Name: service_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 26413)
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO postgres;

--
-- TOC entry 345 (class 1259 OID 26786)
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 26433)
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 26392)
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 26402)
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24608)
-- Name: stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24598)
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 25583)
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 25595)
-- Name: store_currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 25611)
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.tax_provider OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 25633)
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 25647)
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 25619)
-- Name: tax_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 26323)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24585)
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.workflow_execution OWNER TO postgres;

--
-- TOC entry 3980 (class 2604 OID 26583)
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 24581)
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- TOC entry 3872 (class 2604 OID 25840)
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- TOC entry 3884 (class 2604 OID 25907)
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- TOC entry 3930 (class 2604 OID 26193)
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- TOC entry 3924 (class 2604 OID 26159)
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- TOC entry 3916 (class 2604 OID 26129)
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- TOC entry 4884 (class 0 OID 25572)
-- Dependencies: 266
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at) FROM stdin;
apk_01JBYPASJ7CX64V2V1ST9YSV90	pk_7491739a68884aceaec615471867efd7e33e4b4b07bd7ce58bd773af0c893853		pk_749***853	Webshop	publishable	\N		2024-11-05 17:35:33.959+00	\N	\N	2024-11-05 17:35:33.959+00
\.


--
-- TOC entry 4867 (class 0 OID 25251)
-- Dependencies: 249
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 4866 (class 0 OID 25244)
-- Dependencies: 248
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 4928 (class 0 OID 26283)
-- Dependencies: 310
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at) FROM stdin;
authid_01JBYPDQQPSG5JH0M4HRE2GMB8	{"user_id": "user_01JBYPDPWY9M4V4V7QJ4VA9MWY"}	2024-11-05 17:37:10.39+00	2024-11-05 17:37:11.445+00
authid_01JC1M2DX70H1QK4D6G25HQM8E	{"user_id": "user_01JC1M2CNDN7FVRRTTPVZGFMV7"}	2024-11-06 20:53:46.023+00	2024-11-06 20:53:47.055+00
authid_01JC1MRK1QEFPYC37BQ3WM0PWY	{"user_id": "user_01JC1MRHV9WPHAPYNQAAY41VY2"}	2024-11-06 21:05:52.183+00	2024-11-06 21:05:53.411+00
\.


--
-- TOC entry 4899 (class 0 OID 25759)
-- Dependencies: 281
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- TOC entry 4874 (class 0 OID 25400)
-- Dependencies: 256
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
cart_01JC1FV0QG0640QQVGP9X9RESW	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1FWXB9NGEX9TPDSAFZB4V4	sc_01JBYPA6S9ZG068M4VFJQNC33B	lopliok@gmail.com	eur	caaddr_01JC1FWYB7A2B05203KNEWP338	caaddr_01JC1FWYB7P4SXAMJ05MTB7WKS	\N	2024-11-06 19:39:48.849+00	2024-11-06 19:40:51.944+00	\N	\N
cart_01JC1NQ4J2644QFB9G7YBQE3YG	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	sc_01JBYPA6S9ZG068M4VFJQNC33B	hml-tester@hml.cz	eur	caaddr_01JC1NV753F5WKYSBJXKG8XEPK	caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N	2024-11-06 21:22:33.154+00	2024-11-06 21:27:13.857+00	\N	2024-11-06 21:27:12.303+00
cart_01JC65CWYFT35S2BANFZDX3AZY	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1FWXB9NGEX9TPDSAFZB4V4	sc_01JBYPA6S9ZG068M4VFJQNC33B	lopliok@gmail.com	eur	caaddr_01JC68V1QMAWBGJJ2D25ENMAPF	caaddr_01JC68V1QK9GXPYBA6K6NW9VQ6	\N	2024-11-08 15:13:32.623+00	2024-11-08 16:13:42.004+00	\N	\N
cart_01JCE5Y3NW0MMN10CXFNX3B0VD	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	sc_01JBYPA6S9ZG068M4VFJQNC33B	\N	eur	\N	\N	\N	2024-11-11 17:56:52.029+00	2024-11-11 17:56:52.029+00	\N	\N
\.


--
-- TOC entry 4875 (class 0 OID 25415)
-- Dependencies: 257
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01JC1FWYB7P4SXAMJ05MTB7WKS	\N	Lubomír Nedbal	Lubomír	Nedbal	Kostelní Radouň 85		Nová Včelnice	dk	Česká republika	378 42	722902317	\N	2024-11-06 19:40:51.943+00	2024-11-06 19:40:51.943+00	\N
caaddr_01JC1FWYB7A2B05203KNEWP338	\N	Lubomír Nedbal	Lubomír	Nedbal	Kostelní Radouň 85		Nová Včelnice	dk	Česká republika	378 42	722902317	\N	2024-11-06 19:40:51.944+00	2024-11-06 19:40:51.944+00	\N
caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00	\N
caaddr_01JC1NV753F5WKYSBJXKG8XEPK	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00	\N
caaddr_01JC68V1QK9GXPYBA6K6NW9VQ6	\N		Lubomír	Nedbal	Spálená 86/9		Praha 1	dk	South	110 00		\N	2024-11-08 16:13:42.004+00	2024-11-08 16:13:42.004+00	\N
caaddr_01JC68V1QMAWBGJJ2D25ENMAPF	\N		Lubomír	Nedbal	Spálená 86/9		Praha 1	dk	South	110 00		\N	2024-11-08 16:13:42.004+00	2024-11-08 16:13:42.004+00	\N
\.


--
-- TOC entry 4876 (class 0 OID 25424)
-- Dependencies: 258
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at) FROM stdin;
cali_01JC1NQNN7QHZWRC46VSPH20P9	cart_01JC1NQ4J2644QFB9G7YBQE3YG	M / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	2	variant_01JBYPBE916PJQVRTYSQH4HPHN	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:22:50.664+00	2024-11-06 21:25:35.155+00	\N
cali_01JC1FVCQPAQBM4V6F36ZKA3M1	cart_01JC1FV0QG0640QQVGP9X9RESW	L	Medusa Shorts	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	1	variant_01JBYPBE94X1RY6QPC9D54E12H	prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 19:40:01.142+00	2024-11-06 19:41:54.714+00	\N
cali_01JC1NSRFMWADF62NXS0VYWTR3	cart_01JC1NQ4J2644QFB9G7YBQE3YG	S / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	1	variant_01JBYPBE90Y0XBX14X6WRTQFRX	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-S-BLACK	\N	S / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:23:59.093+00	2024-11-06 21:25:35.155+00	\N
cali_01JC65D9DPXWF35N6KV34TFAD5	cart_01JC65CWYFT35S2BANFZDX3AZY	L	Medusa Shorts	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	3	variant_01JBYPBE94X1RY6QPC9D54E12H	prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-08 15:13:45.399+00	2024-11-08 16:30:14.031+00	\N
cali_01JCE5YGDVSY6CJFW218RVK74F	cart_01JCE5Y3NW0MMN10CXFNX3B0VD	Large (36 roses) / Pink / Luxury wrap with silk ribbon	Classic Rose Bouquet	http://localhost:9000/static/1731102278954-roses.jpg	1	variant_01JC6VSD9043GNQ97MGMJBT4HX	prod_01JC6VS1S74ACE8RN57D8P4VD1	Classic Rose Bouquet	A timeless bouquet of fresh roses, perfect for expressing love, gratitude, or admiration.	\N	\N	\N	classic-rose-bouquet	\N	\N	Large (36 roses) / Pink / Luxury wrap with silk ribbon	\N	t	t	f	\N	\N	60	{"value": "60", "precision": 20}	{}	2024-11-11 17:57:05.083+00	2024-11-11 17:57:08.408+00	\N
\.


--
-- TOC entry 4877 (class 0 OID 25450)
-- Dependencies: 259
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- TOC entry 4878 (class 0 OID 25462)
-- Dependencies: 260
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- TOC entry 4948 (class 0 OID 26592)
-- Dependencies: 330
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
cart_01JC1NQ4J2644QFB9G7YBQE3YG	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	capaycol_01JC1NY6EWCN54EWHC7GHYV57X	2024-11-06 21:26:24+00	2024-11-06 21:26:24+00	\N
\.


--
-- TOC entry 4949 (class 0 OID 26605)
-- Dependencies: 331
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4879 (class 0 OID 25473)
-- Dependencies: 261
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
casm_01JC1FYRTFDTHRPPH6ZKK3GBKA	cart_01JC1FV0QG0640QQVGP9X9RESW	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 19:41:51.824+00	2024-11-06 19:41:55.943+00	\N
casm_01JC1NWJ64JXNHWWPZJ29BYWYT	cart_01JC1NQ4J2644QFB9G7YBQE3YG	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 21:25:30.948+00	2024-11-06 21:25:36.45+00	\N
casm_01JC68XFQ7E82N4F6NJFBJ84R9	cart_01JC65CWYFT35S2BANFZDX3AZY	Express Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQQ3Z5W0C1FCWNESSJX	{}	\N	2024-11-08 16:15:01.863+00	2024-11-08 16:30:10.959+00	2024-11-08 16:30:09.937+00
casm_01JC69S6A4S0NV7H5EJ7ZQN0GD	cart_01JC65CWYFT35S2BANFZDX3AZY	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-08 16:30:09.733+00	2024-11-08 16:30:14.97+00	\N
\.


--
-- TOC entry 4880 (class 0 OID 25486)
-- Dependencies: 262
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- TOC entry 4881 (class 0 OID 25497)
-- Dependencies: 263
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- TOC entry 4891 (class 0 OID 25682)
-- Dependencies: 273
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.749+00	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.749+00	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.749+00	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.749+00	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2024-11-05 17:35:01.022+00	2024-11-11 18:01:31.749+00	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.753+00	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.753+00	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2024-11-05 17:35:01.023+00	2024-11-11 18:01:31.75+00	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.75+00	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.75+00	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.751+00	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
try	TL	TL	2	0	{"value": "0", "precision": 20}	Turkish Lira	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2024-11-05 17:35:01.027+00	2024-11-11 18:01:31.755+00	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2024-11-05 17:35:01.024+00	2024-11-11 18:01:31.752+00	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2024-11-05 17:35:01.025+00	2024-11-11 18:01:31.752+00	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2024-11-05 17:35:01.026+00	2024-11-11 18:01:31.754+00	\N
\.


--
-- TOC entry 4869 (class 0 OID 25327)
-- Dependencies: 251
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
cus_01JC1FWXB9NGEX9TPDSAFZB4V4	\N	\N	\N	lopliok@gmail.com	\N	f	\N	2024-11-06 19:40:50.922+00	2024-11-06 19:40:50.922+00	\N	\N
cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	\N	\N	\N	hml-tester@hml.cz	\N	f	\N	2024-11-06 21:24:45.632+00	2024-11-06 21:24:45.632+00	\N	\N
\.


--
-- TOC entry 4870 (class 0 OID 25337)
-- Dependencies: 252
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4871 (class 0 OID 25351)
-- Dependencies: 253
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4872 (class 0 OID 25361)
-- Dependencies: 254
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by) FROM stdin;
\.


--
-- TOC entry 4941 (class 0 OID 26445)
-- Dependencies: 323
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- TOC entry 4932 (class 0 OID 26335)
-- Dependencies: 314
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4943 (class 0 OID 26471)
-- Dependencies: 325
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4942 (class 0 OID 26460)
-- Dependencies: 324
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4933 (class 0 OID 26345)
-- Dependencies: 315
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_provider (id, is_enabled) FROM stdin;
manual_manual	t
\.


--
-- TOC entry 4934 (class 0 OID 26353)
-- Dependencies: 316
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01JBYPAJPFXBEPZA9QMJZEE55N	European Warehouse delivery	shipping	\N	2024-11-05 17:35:26.928+00	2024-11-05 17:35:26.928+00	\N
\.


--
-- TOC entry 4936 (class 0 OID 26376)
-- Dependencies: 318
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01JBYPAJPEMCSM9YH00RSGRMJP	country	gb	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPEF8TTM21BHP3N35VH	country	de	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPERMJKMESK20FVG4S0	country	dk	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPEDRGVQR5T4HEYZ3FD	country	se	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPEG7QMRN5GCZ5RTR2E	country	fr	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPF5RW9RDQQG03NWW5T	country	es	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
fgz_01JBYPAJPFE0PRDK14R5XWC4R2	country	it	\N	\N	serzo_01JBYPAJPF5JJQD2G692VYJY3F	\N	\N	2024-11-05 17:35:26.929+00	2024-11-05 17:35:26.929+00	\N
\.


--
-- TOC entry 4845 (class 0 OID 24777)
-- Dependencies: 227
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
img_01JBYPAY9KA9NQ7HC8FWMXN331	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9K06PEEZPRVPWCYWPG	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9KB7YV5F8XMVPGR1KF	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9K6SADEMS4GGY5K4CR	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9MK34SN99PYAEDPAYF	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9MBK0A5AKACXDBW3XS	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9NHMAXS1X86XCAQFZZ	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9NKC0RP5AA5PA5VPD9	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9N1FDXCKGXCFGN6FWN	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JBYPAY9NHYMRB7MR78X4A1XM	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
img_01JC6VS2BV5WFDJTJ46HQSHYP2	http://localhost:9000/static/1731102278954-roses.jpg	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
\.


--
-- TOC entry 4838 (class 0 OID 24623)
-- Dependencies: 220
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01JBYPBK4TFGBRW15DF20VZY6B	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01JBYPBK4TF0GS9ZFSHHPWK09N	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01JBYPBK4TW63S8CF5JAG3P135	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01JBYPBK4T43KYXWP8G8P59Q5A	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01JBYPBK4TB145EVQ7DXTTV2MP	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01JBYPBK4SMQJPVWWCA6ZEXQFG	2024-11-05 17:36:00.155+00	2024-11-08 22:17:30.586+00	2024-11-08 22:17:30.584+00	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01JBYPBK4SDR5YHFY0XQCTGN41	2024-11-05 17:36:00.156+00	2024-11-08 22:17:32.213+00	2024-11-08 22:17:30.584+00	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01JBYPBK4SQPXQPEXZJBRG4VPC	2024-11-05 17:36:00.155+00	2024-11-08 22:17:34.565+00	2024-11-08 22:17:30.584+00	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01JBYPBK4SZA8MSZY4YYQJ83YV	2024-11-05 17:36:00.155+00	2024-11-08 22:17:36.719+00	2024-11-08 22:17:30.584+00	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS	2024-11-05 17:36:00.155+00	2024-11-08 22:17:39.276+00	2024-11-08 22:17:30.584+00	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01JBYPBK4RFEG2JNM7BT7PNVZZ	2024-11-05 17:36:00.155+00	2024-11-08 22:17:41.097+00	2024-11-08 22:17:30.584+00	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01JBYPBK4S8XJ8GMA10SF09ZF4	2024-11-05 17:36:00.156+00	2024-11-08 22:17:42.856+00	2024-11-08 22:17:30.584+00	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01JBYPBK4S2HGZAJ8WR0HGY8CW	2024-11-05 17:36:00.156+00	2024-11-08 22:17:44.68+00	2024-11-08 22:17:30.584+00	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
iitem_01JBYPBK4VG9NK5QDK245SPQQW	2024-11-05 17:36:00.156+00	2024-11-08 22:18:06.106+00	2024-11-08 22:18:06.106+00	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01JBYPBK4TN728Q6YFV61YGAFX	2024-11-05 17:36:00.156+00	2024-11-08 22:18:07.438+00	2024-11-08 22:18:06.106+00	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01JBYPBK4TE6C43XER003DV064	2024-11-05 17:36:00.156+00	2024-11-08 22:18:09.078+00	2024-11-08 22:18:06.106+00	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01JBYPBK4V87K01E1R6GSXMTD2	2024-11-05 17:36:00.157+00	2024-11-08 22:18:10.611+00	2024-11-08 22:18:06.106+00	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
\.


--
-- TOC entry 4839 (class 0 OID 24635)
-- Dependencies: 221
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01JBYPBQG1KAGW6VCC9C8TBKM4	2024-11-05 17:36:04.612+00	2024-11-05 17:36:04.612+00	\N	iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2P48B0P23QRA3JX6P	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG266FVTHMEMK33H0FS	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2X6CK6R8540EX0KZG	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4T43KYXWP8G8P59Q5A	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2SJTM9WCK2RAEVKV5	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4TB145EVQ7DXTTV2MP	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG25EY64ASN85X1KSVF	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4TF0GS9ZFSHHPWK09N	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG3FCV9921AMRDH4XMY	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4TFGBRW15DF20VZY6B	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG3KRH2TDGMNRBJ90S2	2024-11-05 17:36:04.613+00	2024-11-05 17:36:04.613+00	\N	iitem_01JBYPBK4TW63S8CF5JAG3P135	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG1976K6FK588DR4PMQ	2024-11-05 17:36:04.612+00	2024-11-08 22:17:32.213+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4SMQJPVWWCA6ZEXQFG	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG1J3G9QMPV02K08KKR	2024-11-05 17:36:04.612+00	2024-11-08 22:17:34.565+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4SDR5YHFY0XQCTGN41	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG3RYANV9NBXENAYJHT	2024-11-05 17:36:04.614+00	2024-11-08 22:18:07.437+00	2024-11-08 22:18:06.106+00	iitem_01JBYPBK4VG9NK5QDK245SPQQW	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG31ZTTB6ZDCWW1ASWQ	2024-11-05 17:36:04.613+00	2024-11-08 22:18:09.077+00	2024-11-08 22:18:06.106+00	iitem_01JBYPBK4TN728Q6YFV61YGAFX	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG10SCCWB70HRCCP72R	2024-11-05 17:36:04.612+00	2024-11-08 22:17:36.718+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4SQPXQPEXZJBRG4VPC	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG25XYMMXY835NJNA7F	2024-11-05 17:36:04.612+00	2024-11-08 22:17:39.276+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4SZA8MSZY4YYQJ83YV	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG0ZBE789X5D6AVHC39	2024-11-05 17:36:04.612+00	2024-11-08 22:17:41.097+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG08TJ8ZRW2R5MP5DSK	2024-11-05 17:36:04.612+00	2024-11-08 22:17:42.855+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4RFEG2JNM7BT7PNVZZ	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2YCQMY6G637P1DKGB	2024-11-05 17:36:04.613+00	2024-11-08 22:18:10.611+00	2024-11-08 22:18:06.106+00	iitem_01JBYPBK4TE6C43XER003DV064	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG3CAAZT68WK69MR998	2024-11-05 17:36:04.613+00	2024-11-08 22:18:11.943+00	2024-11-08 22:18:06.106+00	iitem_01JBYPBK4V87K01E1R6GSXMTD2	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG1H1WC5K16YTFXR15W	2024-11-05 17:36:04.612+00	2024-11-08 22:17:44.68+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4S8XJ8GMA10SF09ZF4	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG1KG9YA3EMAE3F4SAG	2024-11-05 17:36:04.612+00	2024-11-08 22:17:46.752+00	2024-11-08 22:17:30.584+00	iitem_01JBYPBK4S2HGZAJ8WR0HGY8CW	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- TOC entry 4930 (class 0 OID 26310)
-- Dependencies: 312
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4947 (class 0 OID 26580)
-- Dependencies: 329
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2024-11-05 17:33:16.602506
2	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2024-11-05 17:33:16.907708
3	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2024-11-05 17:33:17.098939
4	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2024-11-05 17:33:17.298615
5	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2024-11-05 17:33:17.691787
6	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2024-11-05 17:33:17.836735
8	order_promotion	{"toModel": "promotion", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2024-11-05 17:33:17.861086
7	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2024-11-05 17:33:17.861088
9	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2024-11-05 17:33:17.862206
10	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2024-11-05 17:33:17.873544
11	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2024-11-05 17:33:17.881447
12	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2024-11-05 17:33:17.886046
13	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2024-11-05 17:33:17.886044
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2024-11-05 17:33:17.889172
15	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2024-11-05 17:33:17.913845
16	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2024-11-05 17:33:18.431605
\.


--
-- TOC entry 4950 (class 0 OID 26618)
-- Dependencies: 332
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	manual_manual	locfp_01JBYPAHFZYEHXH6WRZGBP5CZ0	2024-11-05 17:35:25+00	2024-11-05 17:35:25+00	\N
\.


--
-- TOC entry 4951 (class 0 OID 26631)
-- Dependencies: 333
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	fuset_01JBYPAJPFXBEPZA9QMJZEE55N	locfs_01JBYPAKPBNJJM0DKCBGN3GY41	2024-11-05 17:35:28+00	2024-11-05 17:35:28+00	\N
\.


--
-- TOC entry 4834 (class 0 OID 24578)
-- Dependencies: 216
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20231228143900	2024-11-05 17:28:54.428256+00
2	Migration20240307161216	2024-11-05 17:29:01.161422+00
3	Migration20240307132720	2024-11-05 17:29:06.007909+00
4	Migration20240719123015	2024-11-05 17:29:06.007909+00
5	InitialSetup20240401153642	2024-11-05 17:29:13.742476+00
6	Migration20240601111544	2024-11-05 17:29:13.742476+00
7	Migration202408271511	2024-11-05 17:29:13.742476+00
8	Migration20230929122253	2024-11-05 17:29:30.499095+00
9	Migration20240322094407	2024-11-05 17:29:30.499095+00
10	Migration20240322113359	2024-11-05 17:29:30.499095+00
11	Migration20240322120125	2024-11-05 17:29:30.499095+00
12	Migration20240626133555	2024-11-05 17:29:30.499095+00
13	Migration20240704094505	2024-11-05 17:29:30.499095+00
14	Migration20240227120221	2024-11-05 17:29:56.714464+00
15	Migration20240617102917	2024-11-05 17:29:56.714464+00
16	Migration20240624153824	2024-11-05 17:29:56.714464+00
17	Migration20240124154000	2024-11-05 17:30:10.949751+00
18	Migration20240524123112	2024-11-05 17:30:10.949751+00
19	Migration20240602110946	2024-11-05 17:30:10.949751+00
20	Migration20240115152146	2024-11-05 17:30:21.404081+00
21	Migration20240222170223	2024-11-05 17:30:25.697027+00
22	Migration20240831125857	2024-11-05 17:30:25.697027+00
23	Migration20240205173216	2024-11-05 17:30:30.458738+00
24	Migration20240624200006	2024-11-05 17:30:30.458738+00
25	InitialSetup20240221144943	2024-11-05 17:30:35.48813+00
26	Migration20240604080145	2024-11-05 17:30:35.48813+00
27	InitialSetup20240227075933	2024-11-05 17:30:40.950929+00
28	Migration20240621145944	2024-11-05 17:30:40.950929+00
29	Migration20240227090331	2024-11-05 17:30:46.908043+00
30	Migration20240710135844	2024-11-05 17:30:46.908043+00
31	Migration20240924114005	2024-11-05 17:30:46.908043+00
32	InitialSetup20240228133303	2024-11-05 17:30:58.319492+00
33	Migration20240624082354	2024-11-05 17:30:58.319492+00
34	Migration20240225134525	2024-11-05 17:31:03.187194+00
35	Migration20240806072619	2024-11-05 17:31:03.187194+00
36	Migration20240219102530	2024-11-05 17:31:10.853086+00
37	Migration20240604100512	2024-11-05 17:31:10.853086+00
38	Migration20240715102100	2024-11-05 17:31:10.853086+00
39	Migration20240715174100	2024-11-05 17:31:10.853086+00
40	Migration20240716081800	2024-11-05 17:31:10.853086+00
41	Migration20240801085921	2024-11-05 17:31:10.853086+00
42	Migration20240821164505	2024-11-05 17:31:10.853086+00
43	Migration20240821170920	2024-11-05 17:31:10.853086+00
44	Migration20240827133639	2024-11-05 17:31:10.853086+00
45	Migration20240902195921	2024-11-05 17:31:10.853086+00
46	Migration20240913092514	2024-11-05 17:31:10.853086+00
47	Migration20240930122627	2024-11-05 17:31:10.853086+00
48	Migration20241014142943	2024-11-05 17:31:10.853086+00
49	Migration20240205025928	2024-11-05 17:31:27.935953+00
50	Migration20240529080336	2024-11-05 17:31:27.935953+00
51	Migration20240214033943	2024-11-05 17:31:41.453998+00
52	Migration20240703095850	2024-11-05 17:31:41.453998+00
53	Migration20240311145700_InitialSetupMigration	2024-11-05 17:31:57.658799+00
54	Migration20240821170957	2024-11-05 17:31:57.658799+00
55	Migration20240917161003	2024-11-05 17:31:57.658799+00
56	Migration20240509083918_InitialSetupMigration	2024-11-05 17:32:22.057533+00
57	Migration20240628075401	2024-11-05 17:32:22.057533+00
58	Migration20240830094712	2024-11-05 17:32:22.057533+00
\.


--
-- TOC entry 4945 (class 0 OID 26556)
-- Dependencies: 327
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
noti_01JBYRGCZBXF9NRKF9EST11JYH		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1730830414182-1730830414155-product-exports.csv", "filename": "1730830414155-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-05 18:13:34.83+00	2024-11-05 18:13:35.674+00	\N	success
noti_01JBYRH6WS9BC5QC33MD84T100		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1730830441006-1730830441006-product-exports.csv", "filename": "1730830441006-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-05 18:14:01.369+00	2024-11-05 18:14:02.159+00	\N	success
noti_01JCE3T0DH2KB72RCBZWYE3PKC		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1731345579739-1731345579737-product-exports.csv", "filename": "1731345579737-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:19:40.466+00	2024-11-11 17:19:41.158+00	\N	success
noti_01JCE55W2MZW9T6MY9Q3HFRZNX		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file custom_lily_romance_product_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:43:37.813+00	2024-11-11 17:43:38.824+00	\N	success
noti_01JCE57QF2EBE6GC4JF3YS8GTY		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file custom_lily_romance_product_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:44:38.626+00	2024-11-11 17:44:39.344+00	\N	success
\.


--
-- TOC entry 4944 (class 0 OID 26548)
-- Dependencies: 326
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2024-11-05 17:35:07.161+00	2024-11-05 17:35:07.161+00	\N
\.


--
-- TOC entry 4903 (class 0 OID 25837)
-- Dependencies: 285
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	1	cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	1	sc_01JBYPA6S9ZG068M4VFJQNC33B	canceled	f	hml-tester@hml.cz	eur	caaddr_01JC1NV753F5WKYSBJXKG8XEPK	caaddr_01JC1NV753PR1XC49BZWQE9ACA	f	\N	2024-11-06 21:27:08.105+00	2024-11-08 22:15:04.879+00	\N	2024-11-08 22:15:04.659+00
\.


--
-- TOC entry 4901 (class 0 OID 25826)
-- Dependencies: 283
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at) FROM stdin;
caaddr_01JC1NV753F5WKYSBJXKG8XEPK	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00
caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00
\.


--
-- TOC entry 4952 (class 0 OID 26644)
-- Dependencies: 334
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	cart_01JC1NQ4J2644QFB9G7YBQE3YG	ordercart_01JC1NZNB97XGC132PDAX3S61X	2024-11-06 21:27:12+00	2024-11-06 21:27:12+00	\N
\.


--
-- TOC entry 4905 (class 0 OID 25889)
-- Dependencies: 287
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 4907 (class 0 OID 25904)
-- Dependencies: 289
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 4925 (class 0 OID 26190)
-- Dependencies: 307
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- TOC entry 4926 (class 0 OID 26213)
-- Dependencies: 308
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4927 (class 0 OID 26226)
-- Dependencies: 309
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4922 (class 0 OID 26156)
-- Dependencies: 304
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- TOC entry 4923 (class 0 OID 26171)
-- Dependencies: 305
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4953 (class 0 OID 26657)
-- Dependencies: 335
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4908 (class 0 OID 25918)
-- Dependencies: 290
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01JC1NZH29KK3B0D1TZAABWJCH	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordli_01JC1NZH288S4WS3MJ4RG4FP3X	2	{"value": "2", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.106+00	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01JC1NZH299WSNS8KAC57267V5	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordli_01JC1NZH28MV8MKF2EYK723HMN	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.106+00	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
\.


--
-- TOC entry 4910 (class 0 OID 25942)
-- Dependencies: 292
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price) FROM stdin;
ordli_01JC1NZH288S4WS3MJ4RG4FP3X	\N	M / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	variant_01JBYPBE916PJQVRTYSQH4HPHN	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:27:08.105+00	2024-11-06 21:27:08.105+00	\N	f
ordli_01JC1NZH28MV8MKF2EYK723HMN	\N	S / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	variant_01JBYPBE90Y0XBX14X6WRTQFRX	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-S-BLACK	\N	S / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:27:08.105+00	2024-11-06 21:27:08.106+00	\N	f
\.


--
-- TOC entry 4912 (class 0 OID 25966)
-- Dependencies: 294
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4911 (class 0 OID 25956)
-- Dependencies: 293
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4954 (class 0 OID 26665)
-- Dependencies: 336
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	ordpay_01JC1NZNXE4FG9E3KCSTXPQ16D	2024-11-06 21:27:13+00	2024-11-06 21:27:13+00	\N
\.


--
-- TOC entry 4955 (class 0 OID 26666)
-- Dependencies: 337
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4909 (class 0 OID 25930)
-- Dependencies: 291
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordspmv_01JC1NZH27JT2X40VVKXAE01GG	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordsm_01JC1NZH27D7CFCR21D8B66RHT	2024-11-06 21:27:08.107+00	2024-11-06 21:27:08.107+00	\N	\N	\N	\N
\.


--
-- TOC entry 4913 (class 0 OID 25976)
-- Dependencies: 295
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
ordsm_01JC1NZH27D7CFCR21D8B66RHT	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 21:27:08.107+00	2024-11-06 21:27:08.107+00	\N	f
\.


--
-- TOC entry 4914 (class 0 OID 25987)
-- Dependencies: 296
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4915 (class 0 OID 25997)
-- Dependencies: 297
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- TOC entry 4904 (class 0 OID 25878)
-- Dependencies: 286
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
ordsum_01JC1NZH27SWJRHX3PZFVCQWKB	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	{"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.107+00	\N
\.


--
-- TOC entry 4916 (class 0 OID 26007)
-- Dependencies: 298
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- TOC entry 4897 (class 0 OID 25741)
-- Dependencies: 279
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, cart_id, order_id, customer_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
pay_01JC1NZD0TAH7A0SSMYA0MHMCM	40	{"value": "40", "precision": 20}	eur	pp_system_default	\N	\N	\N	{}	2024-11-06 21:27:03.962+00	2024-11-08 22:15:05.781+00	\N	\N	2024-11-08 22:15:03.943+00	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	payses_01JC1NY9N9KJ1DQ1233AFDZP6B	\N
\.


--
-- TOC entry 4892 (class 0 OID 25695)
-- Dependencies: 274
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, region_id, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	eur	40	{"value": "40", "precision": 20}	40	{"value": "40", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	2024-11-06 21:26:23.587+00	2024-11-06 21:27:05.184+00	\N	\N	authorized	\N
\.


--
-- TOC entry 4895 (class 0 OID 25723)
-- Dependencies: 277
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- TOC entry 4893 (class 0 OID 25706)
-- Dependencies: 275
-- Data for Name: payment_method_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method_token (id, provider_id, data, name, type_detail, description_detail, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4894 (class 0 OID 25715)
-- Dependencies: 276
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_provider (id, is_enabled) FROM stdin;
pp_system_default	t
\.


--
-- TOC entry 4896 (class 0 OID 25730)
-- Dependencies: 278
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
payses_01JC1NY9N9KJ1DQ1233AFDZP6B	eur	40	{"value": "40", "precision": 20}	pp_system_default	{}	{}	authorized	2024-11-06 21:27:03.771+00	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	\N	2024-11-06 21:26:27.753+00	2024-11-06 21:27:03.963+00	\N
\.


--
-- TOC entry 4855 (class 0 OID 24975)
-- Dependencies: 237
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01JBYPAPZ0MFR384214JTXBX4V	\N	pset_01JBYPAPZ2HAEWHH400PK8M6GF	usd	{"value": "10", "precision": 20}	0	2024-11-05 17:35:31.3+00	2024-11-05 17:35:31.3+00	\N	\N	10	\N	\N
price_01JBYPAPZ15EZXFB5YVGJ8AVM9	\N	pset_01JBYPAPZ2HAEWHH400PK8M6GF	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	\N	10	\N	\N
price_01JBYPAPZ1AYXMQ4ZV57DTHBKF	\N	pset_01JBYPAPZ2HAEWHH400PK8M6GF	eur	{"value": "10", "precision": 20}	1	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	\N	10	\N	\N
price_01JBYPAPZ2NDJ1TYGM3270PYJ2	\N	pset_01JBYPAPZ336WJ0KEYPADK7KMW	usd	{"value": "10", "precision": 20}	0	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	\N	10	\N	\N
price_01JBYPAPZ2P1Z2TXJCN72JS7AH	\N	pset_01JBYPAPZ336WJ0KEYPADK7KMW	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	\N	10	\N	\N
price_01JBYPAPZ3B61PCW1RQQ92H8YK	\N	pset_01JBYPAPZ336WJ0KEYPADK7KMW	eur	{"value": "10", "precision": 20}	1	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	\N	10	\N	\N
price_01JBYPBN42MK0CVBAG86Z3RMEN	\N	pset_01JBYPBN43WFEPMS6Y68FV6BN5	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN433QBQNNYMBW202846	\N	pset_01JBYPBN43WFEPMS6Y68FV6BN5	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	15	\N	\N
price_01JBYPBN43Q0CJ018E09WNPC8H	\N	pset_01JBYPBN43X9Y2563SPBB2G3JQ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN43ENFBXH68XBZZXKCZ	\N	pset_01JBYPBN43X9Y2563SPBB2G3JQ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	15	\N	\N
price_01JBYPBN4312K9NPS8PRW5SQ6M	\N	pset_01JBYPBN4443WRQDKTZEE411C4	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN43M7F3XVKV4BWNZ7H4	\N	pset_01JBYPBN4443WRQDKTZEE411C4	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	15	\N	\N
price_01JBYPBN44SYE828NCRX2QYQ6S	\N	pset_01JBYPBN44ZY6349NTPX34KKY2	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN444AGCDST6SD5RS6M1	\N	pset_01JBYPBN44ZY6349NTPX34KKY2	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	15	\N	\N
price_01JBYPBN442VF7K46G69XH9VWV	\N	pset_01JBYPBN45BKME4FTW7J471GJH	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN443X2NX4CEK93F7F6R	\N	pset_01JBYPBN45BKME4FTW7J471GJH	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	15	\N	\N
price_01JBYPBN454K1V6SGSWX85JCAZ	\N	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N	\N	10	\N	\N
price_01JBYPBN45R9Z3RT48684PCE81	\N	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-05 17:36:02.188+00	\N	\N	15	\N	\N
price_01JBYPBN45RWVKYC2AQRKS1KWK	\N	pset_01JBYPBN45JZZH804E5GQ9GMFW	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-05 17:36:02.188+00	\N	\N	10	\N	\N
price_01JBYPBN4567SE6H8C55ZH1Z3T	\N	pset_01JBYPBN45JZZH804E5GQ9GMFW	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-05 17:36:02.188+00	\N	\N	15	\N	\N
price_01JBYPBN4639DYYY74R65P0VGG	\N	pset_01JBYPBN4655WQ418G1D71R7TT	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-05 17:36:02.188+00	\N	\N	10	\N	\N
price_01JBYPBN46CAWRS634GZGR12BH	\N	pset_01JBYPBN4655WQ418G1D71R7TT	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-05 17:36:02.188+00	\N	\N	15	\N	\N
price_01JBYPBN4673TB4B7FNSASMDNV	\N	pset_01JBYPBN468THKK67R9B1HNB99	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:15.745+00	2024-11-08 22:18:14.536+00	\N	10	\N	\N
price_01JBYPBN46H3MTCTK6DHK53MXW	\N	pset_01JBYPBN468THKK67R9B1HNB99	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:16.447+00	2024-11-08 22:18:14.536+00	\N	15	\N	\N
price_01JBYPBN46VY7DV8Y2PBCZ4HD9	\N	pset_01JBYPBN47F2FPK47JMXS69BDW	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:18.599+00	2024-11-08 22:18:14.536+00	\N	10	\N	\N
price_01JBYPBN47P3MTCQMDMPRMJ1RR	\N	pset_01JBYPBN47F2FPK47JMXS69BDW	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:19.52+00	2024-11-08 22:18:14.536+00	\N	15	\N	\N
price_01JBYPBN47VYBBPQPBYTPVWWNV	\N	pset_01JBYPBN47H115VYH3Y6B04GHJ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:21.646+00	2024-11-08 22:18:14.536+00	\N	10	\N	\N
price_01JBYPBN473TF8GYEQQAJ5GE7C	\N	pset_01JBYPBN47H115VYH3Y6B04GHJ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:22.49+00	2024-11-08 22:18:14.536+00	\N	15	\N	\N
price_01JC6VSWW0YGC8GJQK7WF98KF2	\N	pset_01JC6VSWW0XXBKH908TK4A8SJY	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW11TPW5VB1ZSN3AZYB	\N	pset_01JC6VSWW1F9XJJSSH86AFW96S	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWW1Z2KQSDGY2Y1778T1	\N	pset_01JC6VSWW2CNG3DQE3QH8A9T33	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	60	\N	\N
price_01JC6VSWW2KJAQ6YNAGB26YPHE	\N	pset_01JC6VSWW2N4090GCHRES9Y6EC	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW3Z9QDYS2HC03GJZ6R	\N	pset_01JC6VSWW3HAGCHHE24EQHC447	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWW3B6X9B37FCKRN1TS8	\N	pset_01JC6VSWW38YW1W6N4DB3RGFXW	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	60	\N	\N
price_01JC6VSWW4NBZX7E7K8X42YJRH	\N	pset_01JC6VSWW4DD4FJ3SGQ7BAFK7K	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW4449TVS3026H1K2TF	\N	pset_01JC6VSWW4GCVS2774WB32E6GC	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWW5P6NB17F2KJVWT248	\N	pset_01JC6VSWW5NRYPNP0CQE0HX4QV	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	60	\N	\N
price_01JC6VSWW6W295H0MHN1TR7ERW	\N	pset_01JC6VSWW68CJ8KZX1PXRRDRSD	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW6PFDWMNHE040W6NPC	\N	pset_01JC6VSWW6TKT6SZG25WKR552M	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWW771KQKZS02YEM0DDV	\N	pset_01JC6VSWW71KADN28YKRG294XS	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	60	\N	\N
price_01JC6VSWW7TCZP5HR7JRQ1BJKJ	\N	pset_01JC6VSWW7N36AQPHHYJ64T2XR	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW85WN6FDRT9RWK17VB	\N	pset_01JC6VSWW8QPSWVBJ7QX0C4RY5	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW8DZBQ4FPD54M4N42Y	\N	pset_01JC6VSWW8WGX1ZZP0VW3B4ZRX	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW9816V88W0ZNF1Y5R6	\N	pset_01JC6VSWW94GGEXXSCQ5ANC4SQ	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	30	\N	\N
price_01JC6VSWW9JMWN9CT7M6ENPD1C	\N	pset_01JC6VSWW96WWG1J9KBNDZFRNV	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWWAHACR82YFZEN83DTR	\N	pset_01JC6VSWWAV14CY3TT0SXHGWRK	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N	\N	45	\N	\N
price_01JC6VSWWAQNYQFG59SBE36T9X	\N	pset_01JC6VSWWATJDKW8DXFZAD1BRX	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWBSWWE028C9R0ZFZ49	\N	pset_01JC6VSWWBQ6A0B7G4Z7SX8M16	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWBH97P50KMAFEX10JB	\N	pset_01JC6VSWWBBDPA63CEJHKFY4BQ	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWBFH6GXR57YYDPX034	\N	pset_01JC6VSWWCTMXCQWECYE7AAB3Y	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWC4S2JH2J9G3XS49N7	\N	pset_01JC6VSWWCY1BXDR7BWA5FS4G1	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWDE1P690MQ8EDAENJJ	\N	pset_01JC6VSWWDH1KRPFZ6DYQPX8JM	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWDDT2B31W4STP8EY6X	\N	pset_01JC6VSWWD3M616H72RZ00F148	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	30	\N	\N
price_01JC6VSWWEYRHX978QSGW6NJEQ	\N	pset_01JC6VSWWEWHKRV6H6JV04GTSG	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	30	\N	\N
price_01JC6VSWWEJDTNAXZ9Z0VN3CJM	\N	pset_01JC6VSWWF14BD0KZRXHD27383	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	30	\N	\N
price_01JC6VSWWFYYP0DD22PT1Q1A5M	\N	pset_01JC6VSWWF9769N6HK2M72ZTJB	eur	{"value": "30", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	30	\N	\N
price_01JC6VSWWGKE87JHX6PWJSP02D	\N	pset_01JC6VSWWG67P9TYCF28E7W0CE	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWG6HG196MHPGJSDV6Z	\N	pset_01JC6VSWWGCWJ6MM4EEQTZJ149	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWH9J2RAWRXZJKAB0AX	\N	pset_01JC6VSWWHX14AHCVEGVY8HB8W	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWHP73VCFX85KPKYB8Y	\N	pset_01JC6VSWWHA91FA4EZYWXWQCSP	eur	{"value": "45", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	45	\N	\N
price_01JC6VSWWJX4VJCHD9XQX0W29G	\N	pset_01JC6VSWWJN4MF318XR36B3VDT	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWJPC6ZK70RPB3TKNTZ	\N	pset_01JC6VSWWJ98T66TGPSG97PPMH	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWJWD8XDJ7FB19GQVCB	\N	pset_01JC6VSWWJ1QD5F3TBVMHX1646	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JC6VSWWKBS3MSEXYGCV6AX3C	\N	pset_01JC6VSWWKBCQDF3WNV6WM2WQT	eur	{"value": "60", "precision": 20}	0	2024-11-08 21:45:07.224+00	2024-11-08 21:45:07.224+00	\N	\N	60	\N	\N
price_01JBYPBN3YY1WMRF9WD3CEMQ4C	\N	pset_01JBYPBN3ZSB5CDA2AKB0K1MTZ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:51.666+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN3ZE9EKYKW8X3VHNZWP	\N	pset_01JBYPBN3ZSB5CDA2AKB0K1MTZ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:52.39+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN3ZQW0EJRAFPCTXM3A1	\N	pset_01JBYPBN3ZGA280M79TR4VNNNB	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:54.024+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN47KXBZ406Q10E2BKQ4	\N	pset_01JBYPBN48PFMTABKVTVQCE51B	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:25.766+00	2024-11-08 22:18:14.536+00	\N	15	\N	\N
price_01JBYPBN3ZAQPMEMDY2YCGM13H	\N	pset_01JBYPBN3ZGA280M79TR4VNNNB	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:55.152+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN40KG2EGJB5993W6RJF	\N	pset_01JBYPBN40J76BT5CVPNF50850	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:56.993+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN40T0GACE0RNGQZGX16	\N	pset_01JBYPBN40J76BT5CVPNF50850	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:57.921+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN40HDWNYT7M08Y4F1X2	\N	pset_01JBYPBN40Y90Y5HDFE7F1GW0W	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:17:59.96+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN40PAG6396T7F35FA1C	\N	pset_01JBYPBN40Y90Y5HDFE7F1GW0W	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:00.781+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN41SK4AFDPYA49YQR2Z	\N	pset_01JBYPBN4120ZEAQM70ZA752GZ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:03.136+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN415AZTRDFNMGE538HE	\N	pset_01JBYPBN4120ZEAQM70ZA752GZ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:03.954+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN416GHRN8YGVW3SJ6F2	\N	pset_01JBYPBN41A6QJ0T0CHVS531JZ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:05.672+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN41HTVCDHYK9KAWJH24	\N	pset_01JBYPBN41A6QJ0T0CHVS531JZ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:06.525+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN42J7VW4KT3K4NXKA1W	\N	pset_01JBYPBN42GF6R89MHJ24NMBTK	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:08.665+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN42JQXRP637VK9H7C78	\N	pset_01JBYPBN42GF6R89MHJ24NMBTK	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:09.384+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN42EJJ0E3295JREVFZA	\N	pset_01JBYPBN42C4Q3TE81PD4TS2SZ	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:11.012+00	2024-11-08 22:17:50.06+00	\N	10	\N	\N
price_01JBYPBN42WC9Q7BSWV1ZMHVFQ	\N	pset_01JBYPBN42C4Q3TE81PD4TS2SZ	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-08 22:18:11.634+00	2024-11-08 22:17:50.06+00	\N	15	\N	\N
price_01JBYPBN47722KYV3RNT6KFGJJ	\N	pset_01JBYPBN48PFMTABKVTVQCE51B	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-08 22:18:24.64+00	2024-11-08 22:18:14.536+00	\N	10	\N	\N
\.


--
-- TOC entry 4857 (class 0 OID 25051)
-- Dependencies: 239
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4858 (class 0 OID 25061)
-- Dependencies: 240
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- TOC entry 4859 (class 0 OID 25156)
-- Dependencies: 241
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01JBYPA99JPE3JNQV0RWT4WY52	currency_code	eur	f	2024-11-05 17:35:17.299+00	2024-11-05 17:35:17.299+00	\N
prpref_01JBYPACNJWCMNDY7PNYPESN43	currency_code	usd	f	2024-11-05 17:35:20.754+00	2024-11-05 17:35:20.754+00	\N
prpref_01JBYPAF3AAB1RN71J9VM4MTJ6	region_id	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	f	2024-11-05 17:35:23.242+00	2024-11-05 17:35:23.242+00	\N
\.


--
-- TOC entry 4856 (class 0 OID 25006)
-- Dependencies: 238
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute) FROM stdin;
prule_01JBYPAPZ164388Z7Z454Q4WEZ	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	0	price_01JBYPAPZ1AYXMQ4ZV57DTHBKF	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	region_id
prule_01JBYPAPZ328XWVFRS3B1ADNAT	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	0	price_01JBYPAPZ3B61PCW1RQQ92H8YK	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	region_id
\.


--
-- TOC entry 4854 (class 0 OID 24966)
-- Dependencies: 236
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01JBYPAPZ2HAEWHH400PK8M6GF	2024-11-05 17:35:31.3+00	2024-11-05 17:35:31.3+00	\N
pset_01JBYPAPZ336WJ0KEYPADK7KMW	2024-11-05 17:35:31.3+00	2024-11-05 17:35:31.3+00	\N
pset_01JBYPBN43WFEPMS6Y68FV6BN5	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN43X9Y2563SPBB2G3JQ	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN4443WRQDKTZEE411C4	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN44ZY6349NTPX34KKY2	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN45BKME4FTW7J471GJH	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N
pset_01JBYPBN45Q2XGJ7C6180MYGJ6	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N
pset_01JBYPBN45JZZH804E5GQ9GMFW	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N
pset_01JBYPBN4655WQ418G1D71R7TT	2024-11-05 17:36:02.187+00	2024-11-05 17:36:02.187+00	\N
pset_01JC6VSWW0XXBKH908TK4A8SJY	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW1F9XJJSSH86AFW96S	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW2CNG3DQE3QH8A9T33	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW2N4090GCHRES9Y6EC	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW3HAGCHHE24EQHC447	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW38YW1W6N4DB3RGFXW	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW4DD4FJ3SGQ7BAFK7K	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW4GCVS2774WB32E6GC	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW5NRYPNP0CQE0HX4QV	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW68CJ8KZX1PXRRDRSD	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW6TKT6SZG25WKR552M	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW71KADN28YKRG294XS	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW7N36AQPHHYJ64T2XR	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW8QPSWVBJ7QX0C4RY5	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW8WGX1ZZP0VW3B4ZRX	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW94GGEXXSCQ5ANC4SQ	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWW96WWG1J9KBNDZFRNV	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWAV14CY3TT0SXHGWRK	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWATJDKW8DXFZAD1BRX	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWBQ6A0B7G4Z7SX8M16	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWBBDPA63CEJHKFY4BQ	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWCTMXCQWECYE7AAB3Y	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWCY1BXDR7BWA5FS4G1	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWDH1KRPFZ6DYQPX8JM	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWD3M616H72RZ00F148	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWEWHKRV6H6JV04GTSG	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWF14BD0KZRXHD27383	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWF9769N6HK2M72ZTJB	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWG67P9TYCF28E7W0CE	2024-11-08 21:45:07.222+00	2024-11-08 21:45:07.222+00	\N
pset_01JC6VSWWGCWJ6MM4EEQTZJ149	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWHX14AHCVEGVY8HB8W	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWHA91FA4EZYWXWQCSP	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWJN4MF318XR36B3VDT	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWJ98T66TGPSG97PPMH	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWJ1QD5F3TBVMHX1646	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JC6VSWWKBCQDF3WNV6WM2WQT	2024-11-08 21:45:07.223+00	2024-11-08 21:45:07.223+00	\N
pset_01JBYPBN3ZSB5CDA2AKB0K1MTZ	2024-11-05 17:36:02.186+00	2024-11-08 22:17:50.061+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN3ZGA280M79TR4VNNNB	2024-11-05 17:36:02.186+00	2024-11-08 22:17:52.391+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN40J76BT5CVPNF50850	2024-11-05 17:36:02.186+00	2024-11-08 22:17:55.152+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN40Y90Y5HDFE7F1GW0W	2024-11-05 17:36:02.186+00	2024-11-08 22:17:57.921+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN4120ZEAQM70ZA752GZ	2024-11-05 17:36:02.186+00	2024-11-08 22:18:00.782+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN41A6QJ0T0CHVS531JZ	2024-11-05 17:36:02.186+00	2024-11-08 22:18:03.954+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN42GF6R89MHJ24NMBTK	2024-11-05 17:36:02.186+00	2024-11-08 22:18:06.526+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN42C4Q3TE81PD4TS2SZ	2024-11-05 17:36:02.186+00	2024-11-08 22:18:09.385+00	2024-11-08 22:17:50.06+00
pset_01JBYPBN468THKK67R9B1HNB99	2024-11-05 17:36:02.187+00	2024-11-08 22:18:14.536+00	2024-11-08 22:18:14.536+00
pset_01JBYPBN47F2FPK47JMXS69BDW	2024-11-05 17:36:02.187+00	2024-11-08 22:18:16.447+00	2024-11-08 22:18:14.536+00
pset_01JBYPBN47H115VYH3Y6B04GHJ	2024-11-05 17:36:02.187+00	2024-11-08 22:18:19.52+00	2024-11-08 22:18:14.536+00
pset_01JBYPBN48PFMTABKVTVQCE51B	2024-11-05 17:36:02.187+00	2024-11-08 22:18:22.49+00	2024-11-08 22:18:14.536+00
\.


--
-- TOC entry 4841 (class 0 OID 24721)
-- Dependencies: 223
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01JBYPAX9MZD59BMNW71AXBF23	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N	\N
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N	\N
prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:48.911+00	2024-11-08 22:17:48.911+00	\N
prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:13.745+00	2024-11-08 22:18:13.744+00	\N
prod_01JC6VS1S74ACE8RN57D8P4VD1	Classic Rose Bouquet	classic-rose-bouquet	\N	A timeless bouquet of fresh roses, perfect for expressing love, gratitude, or admiration.	f	published	http://localhost:9000/static/1731102278954-roses.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N	\N
\.


--
-- TOC entry 4849 (class 0 OID 24821)
-- Dependencies: 231
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01JBYPAV9J63ACGHK3EZF986YP	Shirts		shirts	pcat_01JBYPAV9J63ACGHK3EZF986YP	t	f	0	\N	2024-11-05 17:35:36.284+00	2024-11-05 17:35:36.284+00	\N	\N
pcat_01JBYPAVFYDGSV952FVKMRE42H	Sweatshirts		sweatshirts	pcat_01JBYPAVFYDGSV952FVKMRE42H	t	f	1	\N	2024-11-05 17:35:36.284+00	2024-11-05 17:35:36.284+00	\N	\N
pcat_01JBYPAVNGEVRA2JPAGANW1HB6	Pants		pants	pcat_01JBYPAVNGEVRA2JPAGANW1HB6	t	f	2	\N	2024-11-05 17:35:36.285+00	2024-11-05 17:35:36.285+00	\N	\N
pcat_01JBYPAVTWVYWGJWEXT8QGBPXY	Merch		merch	pcat_01JBYPAVTWVYWGJWEXT8QGBPXY	t	f	3	\N	2024-11-05 17:35:36.285+00	2024-11-05 17:35:36.285+00	\N	\N
\.


--
-- TOC entry 4852 (class 0 OID 24851)
-- Dependencies: 234
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01JBYPAX9KTG1VRTK059RV2VWZ	pcat_01JBYPAV9J63ACGHK3EZF986YP
prod_01JBYPAX9MZD59BMNW71AXBF23	pcat_01JBYPAVFYDGSV952FVKMRE42H
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	pcat_01JBYPAVNGEVRA2JPAGANW1HB6
prod_01JBYPAX9MM5R7BNNF72RKRWEY	pcat_01JBYPAVTWVYWGJWEXT8QGBPXY
\.


--
-- TOC entry 4848 (class 0 OID 24810)
-- Dependencies: 230
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4851 (class 0 OID 24844)
-- Dependencies: 233
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (product_id, image_id) FROM stdin;
prod_01JBYPAX9KTG1VRTK059RV2VWZ	img_01JBYPAY9KA9NQ7HC8FWMXN331
prod_01JBYPAX9KTG1VRTK059RV2VWZ	img_01JBYPAY9K06PEEZPRVPWCYWPG
prod_01JBYPAX9KTG1VRTK059RV2VWZ	img_01JBYPAY9KB7YV5F8XMVPGR1KF
prod_01JBYPAX9KTG1VRTK059RV2VWZ	img_01JBYPAY9K6SADEMS4GGY5K4CR
prod_01JBYPAX9MZD59BMNW71AXBF23	img_01JBYPAY9MK34SN99PYAEDPAYF
prod_01JBYPAX9MZD59BMNW71AXBF23	img_01JBYPAY9MBK0A5AKACXDBW3XS
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	img_01JBYPAY9NHMAXS1X86XCAQFZZ
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	img_01JBYPAY9NKC0RP5AA5PA5VPD9
prod_01JBYPAX9MM5R7BNNF72RKRWEY	img_01JBYPAY9N1FDXCKGXCFGN6FWN
prod_01JBYPAX9MM5R7BNNF72RKRWEY	img_01JBYPAY9NHYMRB7MR78X4A1XM
prod_01JC6VS1S74ACE8RN57D8P4VD1	img_01JC6VS2BV5WFDJTJ46HQSHYP2
\.


--
-- TOC entry 4843 (class 0 OID 24755)
-- Dependencies: 225
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01JBYPB4WTHM535A7FEV9TNXKC	Size	prod_01JBYPAX9MZD59BMNW71AXBF23	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
opt_01JBYPB4WVJMG3R7WSWVAAXHZR	Size	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	Size	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
opt_01JC6VS3NF1PS4NTVVFH4ATR3J	Color	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
opt_01JC6VS3NGF8EQTMCGY8SYXKVT	Wrapping Style	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
opt_01JBYPB4WTQ648S23QZCGH6M03	Size	prod_01JBYPAX9KTG1VRTK059RV2VWZ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:49.832+00	2024-11-08 22:17:48.911+00
opt_01JBYPB4WT12SATPCJVHP6BTXR	Color	prod_01JBYPAX9KTG1VRTK059RV2VWZ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
opt_01JBYPB4WVAJ1C086RCCG4XAYQ	Size	prod_01JBYPAX9MM5R7BNNF72RKRWEY	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:14.308+00	2024-11-08 22:18:13.744+00
\.


--
-- TOC entry 4844 (class 0 OID 24766)
-- Dependencies: 226
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01JBYPB66BSV8KKNMJE5RQGJMF	S	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66C2J1MBV7XAW61JJT1	M	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66CM34CM0TB0GQJGNSH	L	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66CMXY4TR6M25G2Y3SP	XL	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB6CS8X5RZ5P8H21SY2QD	S	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB6CSNMBJ8R9Z2GWK8388	M	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB6CS0DAKGQ6W717NQ1JK	L	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB6CSKD4Y40V7MKP63DFG	XL	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JC6VS50TC1QBR8627E1XQJRP	Small (12 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50TQ4NGWAV72QCFS8NH	Medium (24 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50VW0T89WR5DVDNJ675	Large (36 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50V92WYR9TYHXKQYSJY	Red	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50VTS551J26WN8WVARM	Pink	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50WQQRCQ1HYWHGGPWAS	White	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50WS90P8K2G6YCG3CQP	Mixed	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50W9V131W8SVS2ZD343	Classic paper wrap	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50XSJ7G6D808CA70B1W	Ribbon-tied with rustic burlap	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JC6VS50XKHHH0PY9DB37989C	Luxury wrap with silk ribbon	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-08 21:44:39.080448+00	\N
optval_01JBYPB6003F25SB0TTSKQCZMV	S	opt_01JBYPB4WTQ648S23QZCGH6M03	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
optval_01JBYPB600MP9EHGS4WZMYPV7D	M	opt_01JBYPB4WTQ648S23QZCGH6M03	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
optval_01JBYPB6007KT9XH6PZDCW2X5R	L	opt_01JBYPB4WTQ648S23QZCGH6M03	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
optval_01JBYPB600190CTGHF2JTGBS84	XL	opt_01JBYPB4WTQ648S23QZCGH6M03	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
optval_01JBYPB600QP4V9P68T06AZ42S	Black	opt_01JBYPB4WT12SATPCJVHP6BTXR	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:52.386+00	2024-11-08 22:17:48.911+00
optval_01JBYPB6013TFTH2WAB7ANQFC2	White	opt_01JBYPB4WT12SATPCJVHP6BTXR	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:52.386+00	2024-11-08 22:17:48.911+00
optval_01JBYPB6J5DV7E3R6ESDZFC42F	S	opt_01JBYPB4WVAJ1C086RCCG4XAYQ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:15.288+00	2024-11-08 22:18:13.744+00
optval_01JBYPB6J5Z6NM77RQFB9TTW78	M	opt_01JBYPB4WVAJ1C086RCCG4XAYQ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:15.288+00	2024-11-08 22:18:13.744+00
optval_01JBYPB6J54149R4S43P20W43E	L	opt_01JBYPB4WVAJ1C086RCCG4XAYQ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
optval_01JBYPB6J55MPH4433CMFNJ1NV	XL	opt_01JBYPB4WVAJ1C086RCCG4XAYQ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
\.


--
-- TOC entry 4960 (class 0 OID 26710)
-- Dependencies: 342
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01JBYPAX9MZD59BMNW71AXBF23	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9KF0FP6NPBC4VA8BFK	2024-11-05 17:35:54+00	2024-11-05 17:35:54+00	\N
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9KBCEFJ64ZW159M894	2024-11-05 17:35:54+00	2024-11-05 17:35:54+00	\N
prod_01JC6VS1S74ACE8RN57D8P4VD1	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JC6VSBVWKWX6JS0R2VKD036T	2024-11-08 21:44:50+00	2024-11-08 21:44:50+00	\N
prod_01JBYPAX9KTG1VRTK059RV2VWZ	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9JRKNRKZ1GSRC2R8GA	2024-11-05 17:35:54+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
prod_01JBYPAX9MM5R7BNNF72RKRWEY	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9MT97HEKTS3WJ68K5W	2024-11-05 17:35:54+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
\.


--
-- TOC entry 4846 (class 0 OID 24788)
-- Dependencies: 228
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptag_01JCE3PMFMAGK79WN57QGK7C8R	flower	\N	2024-11-11 17:17:49.94+00	2024-11-11 17:17:49.94+00	\N
\.


--
-- TOC entry 4850 (class 0 OID 24837)
-- Dependencies: 232
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
prod_01JC6VS1S74ACE8RN57D8P4VD1	ptag_01JCE3PMFMAGK79WN57QGK7C8R
\.


--
-- TOC entry 4847 (class 0 OID 24799)
-- Dependencies: 229
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4842 (class 0 OID 24737)
-- Dependencies: 224
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93969VX8HEZJCR4NNP	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE946EJBD22K26AH4183	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE94YNRC1A69J20EDDR8	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JC6VSD8NN7D5QF2BET7MZNAK	Small (12 roses) / Red / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.234+00	2024-11-08 21:44:51.234+00	\N
variant_01JC6VSD8NKFC71R3ZXV09T13S	Medium (24 roses) / Red / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	Large (36 roses) / Red / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	Small (12 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PN2PTSVWFDAE1E441	Medium (24 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	Large (36 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8P74MGBPZFDT9CW52G	Small (12 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PXRADW9HHCGAAD7FG	Medium (24 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PHJZSQ1RBV989AXRR	Large (36 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PKPYWBF361CAY0X9J	Small (12 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Q02VSYREYC15C1MEM	Medium (24 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	Large (36 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8QC934X4R9T229VCD5	Small (12 roses) / Red / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	Small (12 roses) / Pink / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8RZWPF0E69A0ABPH8F	Small (12 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8S5501MRHX4J4RG5AZ	Small (12 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	Medium (24 roses) / Red / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	Medium (24 roses) / Pink / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	Medium (24 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8TH1F446A21F39E757	Medium (24 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	Large (36 roses) / Red / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8V633FNXPCW33RA207	Large (36 roses) / Pink / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8VR9VYX9Q9NB775AGH	Large (36 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8WNJJ8221A0B7J4CPF	Large (36 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8WB4P91GB8RD6VVC5B	Small (12 roses) / Red / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8W75WP4W76WCP649V1	Small (12 roses) / Pink / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8X15DMR213E5MAJ2HT	Small (12 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8X7FBRK812ZYD0235G	Small (12 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JBYPBE90Y0XBX14X6WRTQFRX	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.174+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE94FG87CR5AG1W9E1Q9	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE94W3J0DR77V2T1NRZD	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE94X1RY6QPC9D54E12H	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE95B901P7H677QKWZNW	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JC6VSD8XNX2814PPVRHM4MBV	Medium (24 roses) / Red / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	Medium (24 roses) / Pink / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	Medium (24 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	Medium (24 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	Large (36 roses) / Red / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD9043GNQ97MGMJBT4HX	Large (36 roses) / Pink / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD919HA7JS3T8EXZBSWX	Large (36 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	Large (36 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.236+00	2024-11-08 21:44:51.236+00	\N
variant_01JBYPBE918XY9ZYK9G7MNV363	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE916PJQVRTYSQH4HPHN	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE91TCGBFJ0HECT809G1	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE921XBK4BG0NSA18CSC	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92CN934BR1AVBXK686	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92AWZRSMTER2T555QG	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
\.


--
-- TOC entry 4957 (class 0 OID 26687)
-- Dependencies: 339
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	pvitem_01JBYPBMGRTJ50TJ54BKJJGGH1	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	iitem_01JBYPBK4TFGBRW15DF20VZY6B	pvitem_01JBYPBMGRT855K922F0AJ9HBY	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	iitem_01JBYPBK4TF0GS9ZFSHHPWK09N	pvitem_01JBYPBMGRMD5DRV94MXXGRW4V	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	iitem_01JBYPBK4TW63S8CF5JAG3P135	pvitem_01JBYPBMGR57CAW1VB8QE2F9MD	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	iitem_01JBYPBK4T43KYXWP8G8P59Q5A	pvitem_01JBYPBMGREW3E5S7A2XMNSNJ1	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93969VX8HEZJCR4NNP	iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	pvitem_01JBYPBMGRVHRJSKEFT5XC8QEP	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE946EJBD22K26AH4183	iitem_01JBYPBK4TB145EVQ7DXTTV2MP	pvitem_01JBYPBMGRPSQFBX37SRVYKM1S	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE94YNRC1A69J20EDDR8	iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	pvitem_01JBYPBMGS39BCSXCBXG580BQC	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE90Y0XBX14X6WRTQFRX	iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS	pvitem_01JBYPBMGP1M9HQ7KVGJDVZD6T	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE918XY9ZYK9G7MNV363	iitem_01JBYPBK4RFEG2JNM7BT7PNVZZ	pvitem_01JBYPBMGQ221RFCC7AD7M0G5M	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE916PJQVRTYSQH4HPHN	iitem_01JBYPBK4SQPXQPEXZJBRG4VPC	pvitem_01JBYPBMGQXXA6418H38VWVARZ	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE91TCGBFJ0HECT809G1	iitem_01JBYPBK4SZA8MSZY4YYQJ83YV	pvitem_01JBYPBMGQ01QAJV6JV6T9CCY6	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE921XBK4BG0NSA18CSC	iitem_01JBYPBK4SMQJPVWWCA6ZEXQFG	pvitem_01JBYPBMGQ04HS4VYY5S22WVY7	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	iitem_01JBYPBK4SDR5YHFY0XQCTGN41	pvitem_01JBYPBMGQM7BXWH77VMSWFZ08	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE92CN934BR1AVBXK686	iitem_01JBYPBK4S8XJ8GMA10SF09ZF4	pvitem_01JBYPBMGR04YV562NHWYYT3PB	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE92AWZRSMTER2T555QG	iitem_01JBYPBK4S2HGZAJ8WR0HGY8CW	pvitem_01JBYPBMGRT9D8A4784APT2J9F	1	2024-11-05 17:36:01+00	2024-11-08 22:17:48+00	2024-11-08 22:17:48+00
variant_01JBYPBE94FG87CR5AG1W9E1Q9	iitem_01JBYPBK4TE6C43XER003DV064	pvitem_01JBYPBMGS7KCKC22ZGQ21FP0F	1	2024-11-05 17:36:01+00	2024-11-08 22:18:13+00	2024-11-08 22:18:13+00
variant_01JBYPBE94W3J0DR77V2T1NRZD	iitem_01JBYPBK4TN728Q6YFV61YGAFX	pvitem_01JBYPBMGS3M8ZSYA66XSKJW02	1	2024-11-05 17:36:01+00	2024-11-08 22:18:13+00	2024-11-08 22:18:13+00
variant_01JBYPBE94X1RY6QPC9D54E12H	iitem_01JBYPBK4VG9NK5QDK245SPQQW	pvitem_01JBYPBMGSAQ7CVRNJC31STF4K	1	2024-11-05 17:36:01+00	2024-11-08 22:18:13+00	2024-11-08 22:18:13+00
variant_01JBYPBE95B901P7H677QKWZNW	iitem_01JBYPBK4V87K01E1R6GSXMTD2	pvitem_01JBYPBMGS76H1M6BTXHA3ED9X	1	2024-11-05 17:36:01+00	2024-11-08 22:18:13+00	2024-11-08 22:18:13+00
\.


--
-- TOC entry 4853 (class 0 OID 24858)
-- Dependencies: 235
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01JBYPBE90Y0XBX14X6WRTQFRX	optval_01JBYPB6003F25SB0TTSKQCZMV
variant_01JBYPBE90Y0XBX14X6WRTQFRX	optval_01JBYPB600QP4V9P68T06AZ42S
variant_01JBYPBE918XY9ZYK9G7MNV363	optval_01JBYPB6003F25SB0TTSKQCZMV
variant_01JBYPBE918XY9ZYK9G7MNV363	optval_01JBYPB6013TFTH2WAB7ANQFC2
variant_01JBYPBE916PJQVRTYSQH4HPHN	optval_01JBYPB600MP9EHGS4WZMYPV7D
variant_01JBYPBE916PJQVRTYSQH4HPHN	optval_01JBYPB600QP4V9P68T06AZ42S
variant_01JBYPBE91TCGBFJ0HECT809G1	optval_01JBYPB600MP9EHGS4WZMYPV7D
variant_01JBYPBE91TCGBFJ0HECT809G1	optval_01JBYPB6013TFTH2WAB7ANQFC2
variant_01JBYPBE921XBK4BG0NSA18CSC	optval_01JBYPB6007KT9XH6PZDCW2X5R
variant_01JBYPBE921XBK4BG0NSA18CSC	optval_01JBYPB600QP4V9P68T06AZ42S
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	optval_01JBYPB6007KT9XH6PZDCW2X5R
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	optval_01JBYPB6013TFTH2WAB7ANQFC2
variant_01JBYPBE92CN934BR1AVBXK686	optval_01JBYPB600190CTGHF2JTGBS84
variant_01JBYPBE92CN934BR1AVBXK686	optval_01JBYPB600QP4V9P68T06AZ42S
variant_01JBYPBE92AWZRSMTER2T555QG	optval_01JBYPB600190CTGHF2JTGBS84
variant_01JBYPBE92AWZRSMTER2T555QG	optval_01JBYPB6013TFTH2WAB7ANQFC2
variant_01JBYPBE93PM2NXG8HQFB6D16H	optval_01JBYPB66BSV8KKNMJE5RQGJMF
variant_01JBYPBE93ZZZWF21FA1W7WB5C	optval_01JBYPB66C2J1MBV7XAW61JJT1
variant_01JBYPBE93GJCNSA5BFXD54W3K	optval_01JBYPB66CM34CM0TB0GQJGNSH
variant_01JBYPBE931101X6XAQC2W1JRV	optval_01JBYPB66CMXY4TR6M25G2Y3SP
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	optval_01JBYPB6CS8X5RZ5P8H21SY2QD
variant_01JBYPBE93969VX8HEZJCR4NNP	optval_01JBYPB6CSNMBJ8R9Z2GWK8388
variant_01JBYPBE946EJBD22K26AH4183	optval_01JBYPB6CS0DAKGQ6W717NQ1JK
variant_01JBYPBE94YNRC1A69J20EDDR8	optval_01JBYPB6CSKD4Y40V7MKP63DFG
variant_01JBYPBE94FG87CR5AG1W9E1Q9	optval_01JBYPB6J5DV7E3R6ESDZFC42F
variant_01JBYPBE94W3J0DR77V2T1NRZD	optval_01JBYPB6J5Z6NM77RQFB9TTW78
variant_01JBYPBE94X1RY6QPC9D54E12H	optval_01JBYPB6J54149R4S43P20W43E
variant_01JBYPBE95B901P7H677QKWZNW	optval_01JBYPB6J55MPH4433CMFNJ1NV
variant_01JC6VSD8NN7D5QF2BET7MZNAK	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8NN7D5QF2BET7MZNAK	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8NN7D5QF2BET7MZNAK	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8NKFC71R3ZXV09T13S	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8NKFC71R3ZXV09T13S	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8NKFC71R3ZXV09T13S	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8PN2PTSVWFDAE1E441	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8PN2PTSVWFDAE1E441	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8PN2PTSVWFDAE1E441	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8P74MGBPZFDT9CW52G	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8P74MGBPZFDT9CW52G	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8P74MGBPZFDT9CW52G	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8PXRADW9HHCGAAD7FG	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8PXRADW9HHCGAAD7FG	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8PXRADW9HHCGAAD7FG	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8PHJZSQ1RBV989AXRR	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8PHJZSQ1RBV989AXRR	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8PHJZSQ1RBV989AXRR	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8PKPYWBF361CAY0X9J	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8PKPYWBF361CAY0X9J	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8PKPYWBF361CAY0X9J	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8Q02VSYREYC15C1MEM	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8Q02VSYREYC15C1MEM	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8Q02VSYREYC15C1MEM	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8QC934X4R9T229VCD5	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8QC934X4R9T229VCD5	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8QC934X4R9T229VCD5	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8RZWPF0E69A0ABPH8F	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8RZWPF0E69A0ABPH8F	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8RZWPF0E69A0ABPH8F	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8S5501MRHX4J4RG5AZ	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8S5501MRHX4J4RG5AZ	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8S5501MRHX4J4RG5AZ	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8TH1F446A21F39E757	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8TH1F446A21F39E757	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8TH1F446A21F39E757	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8V633FNXPCW33RA207	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8V633FNXPCW33RA207	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8V633FNXPCW33RA207	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8VR9VYX9Q9NB775AGH	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8VR9VYX9Q9NB775AGH	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8VR9VYX9Q9NB775AGH	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8WNJJ8221A0B7J4CPF	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8WNJJ8221A0B7J4CPF	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8WNJJ8221A0B7J4CPF	optval_01JC6VS50XSJ7G6D808CA70B1W
variant_01JC6VSD8WB4P91GB8RD6VVC5B	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8WB4P91GB8RD6VVC5B	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8WB4P91GB8RD6VVC5B	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8W75WP4W76WCP649V1	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8W75WP4W76WCP649V1	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8W75WP4W76WCP649V1	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8XNX2814PPVRHM4MBV	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8XNX2814PPVRHM4MBV	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8XNX2814PPVRHM4MBV	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	optval_01JC6VS50TQ4NGWAV72QCFS8NH
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	optval_01JC6VS50V92WYR9TYHXKQYSJY
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD9043GNQ97MGMJBT4HX	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD9043GNQ97MGMJBT4HX	optval_01JC6VS50VTS551J26WN8WVARM
variant_01JC6VSD9043GNQ97MGMJBT4HX	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD919HA7JS3T8EXZBSWX	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD919HA7JS3T8EXZBSWX	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD919HA7JS3T8EXZBSWX	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	optval_01JC6VS50VW0T89WR5DVDNJ675
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	optval_01JC6VS50XKHHH0PY9DB37989C
\.


--
-- TOC entry 4958 (class 0 OID 26695)
-- Dependencies: 340
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	pset_01JBYPBN43WFEPMS6Y68FV6BN5	pvps_01JBYPBPCV92J2B4BMB2HDJZ82	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	pset_01JBYPBN43X9Y2563SPBB2G3JQ	pvps_01JBYPBPCVK98D1QFN3HQ0MQFR	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	pset_01JBYPBN4443WRQDKTZEE411C4	pvps_01JBYPBPCVQYHEGK7J77MCHCGJ	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	pset_01JBYPBN44ZY6349NTPX34KKY2	pvps_01JBYPBPCV69MH51K6NSRW9XQS	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	pset_01JBYPBN45BKME4FTW7J471GJH	pvps_01JBYPBPCV0Q9WAMM1YG2ACDYE	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93969VX8HEZJCR4NNP	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	pvps_01JBYPBPCVV2JE32NV43XKPDP7	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE946EJBD22K26AH4183	pset_01JBYPBN45JZZH804E5GQ9GMFW	pvps_01JBYPBPCVK7HDJW9P62NNW3X0	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE94YNRC1A69J20EDDR8	pset_01JBYPBN4655WQ418G1D71R7TT	pvps_01JBYPBPCVC2MAQB2J3AR9HT6E	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JC6VSD8NN7D5QF2BET7MZNAK	pset_01JC6VSWW0XXBKH908TK4A8SJY	pvps_01JC6VSY8NGXACY6TDVSARVZNM	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8NKFC71R3ZXV09T13S	pset_01JC6VSWW1F9XJJSSH86AFW96S	pvps_01JC6VSY8PCZJAKX8RZGXMRAQH	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	pset_01JC6VSWW2CNG3DQE3QH8A9T33	pvps_01JC6VSY8PE7FSQ43CRXYZ9DY3	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	pset_01JC6VSWW2N4090GCHRES9Y6EC	pvps_01JC6VSY8Q9340MC4JBPCT40Z4	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8PN2PTSVWFDAE1E441	pset_01JC6VSWW3HAGCHHE24EQHC447	pvps_01JC6VSY8QBJZX182PXQ52D8EP	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	pset_01JC6VSWW38YW1W6N4DB3RGFXW	pvps_01JC6VSY8QQBE54JB52VY663H1	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8P74MGBPZFDT9CW52G	pset_01JC6VSWW4DD4FJ3SGQ7BAFK7K	pvps_01JC6VSY8QBETVA88P5VF0P58Z	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8PXRADW9HHCGAAD7FG	pset_01JC6VSWW4GCVS2774WB32E6GC	pvps_01JC6VSY8R2S43FR2DV8SGDNSM	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8PHJZSQ1RBV989AXRR	pset_01JC6VSWW5NRYPNP0CQE0HX4QV	pvps_01JC6VSY8RQYBR3VE6D0GP5MNB	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8PKPYWBF361CAY0X9J	pset_01JC6VSWW68CJ8KZX1PXRRDRSD	pvps_01JC6VSY8RWNEQGN5717AYQ6G2	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8Q02VSYREYC15C1MEM	pset_01JC6VSWW6TKT6SZG25WKR552M	pvps_01JC6VSY8RZ49V7ZXSGCKEVYRY	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	pset_01JC6VSWW71KADN28YKRG294XS	pvps_01JC6VSY8SYA2WMDRARM4YS2KF	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8QC934X4R9T229VCD5	pset_01JC6VSWW7N36AQPHHYJ64T2XR	pvps_01JC6VSY8S3HS6RKFXYWJ7K1MV	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	pset_01JC6VSWW8QPSWVBJ7QX0C4RY5	pvps_01JC6VSY8SSB5SWPGG5H75TG1M	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8RZWPF0E69A0ABPH8F	pset_01JC6VSWW8WGX1ZZP0VW3B4ZRX	pvps_01JC6VSY8S62R9RTWHM7MT4PGZ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8S5501MRHX4J4RG5AZ	pset_01JC6VSWW94GGEXXSCQ5ANC4SQ	pvps_01JC6VSY8T8T77TJFB5ZR1H311	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	pset_01JC6VSWW96WWG1J9KBNDZFRNV	pvps_01JC6VSY8TMH609ZSK06M680MJ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	pset_01JC6VSWWAV14CY3TT0SXHGWRK	pvps_01JC6VSY8TA7GCNN0W63MX5EH4	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	pset_01JC6VSWWATJDKW8DXFZAD1BRX	pvps_01JC6VSY8TZPV6D8NCNWHGTX6M	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8TH1F446A21F39E757	pset_01JC6VSWWBQ6A0B7G4Z7SX8M16	pvps_01JC6VSY8TW2QRRQTM8KMTRP5V	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	pset_01JC6VSWWBBDPA63CEJHKFY4BQ	pvps_01JC6VSY8T25J81AEGXCNMBXZ7	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8V633FNXPCW33RA207	pset_01JC6VSWWCTMXCQWECYE7AAB3Y	pvps_01JC6VSY8TAXGYFJKPBE5EZE54	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8VR9VYX9Q9NB775AGH	pset_01JC6VSWWCY1BXDR7BWA5FS4G1	pvps_01JC6VSY8TF68NW0N1B7JZYRP7	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8WNJJ8221A0B7J4CPF	pset_01JC6VSWWDH1KRPFZ6DYQPX8JM	pvps_01JC6VSY8T2YFQD6TKMVEN3NPJ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8WB4P91GB8RD6VVC5B	pset_01JC6VSWWD3M616H72RZ00F148	pvps_01JC6VSY8T9EM9H2T7S113FH5H	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8W75WP4W76WCP649V1	pset_01JC6VSWWEWHKRV6H6JV04GTSG	pvps_01JC6VSY8TY0G5F9D6SFNQ25ZB	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8X15DMR213E5MAJ2HT	pset_01JC6VSWWF14BD0KZRXHD27383	pvps_01JC6VSY8TXRDNKQYR7BZ878BH	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8X7FBRK812ZYD0235G	pset_01JC6VSWWF9769N6HK2M72ZTJB	pvps_01JC6VSY8TPPAM2C7AYRDQS7AJ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8XNX2814PPVRHM4MBV	pset_01JC6VSWWG67P9TYCF28E7W0CE	pvps_01JC6VSY8TJ6NSTKT0HG6C36VJ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	pset_01JC6VSWWGCWJ6MM4EEQTZJ149	pvps_01JC6VSY8TDT9XAYRFKT7KFFF2	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	pset_01JC6VSWWHX14AHCVEGVY8HB8W	pvps_01JC6VSY8VAFPVBJQ3ZED961SX	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	pset_01JC6VSWWHA91FA4EZYWXWQCSP	pvps_01JC6VSY8VTGC1KRV1CJ5WX5XN	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	pset_01JC6VSWWJN4MF318XR36B3VDT	pvps_01JC6VSY8VP24NXZH1J55AP67R	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD9043GNQ97MGMJBT4HX	pset_01JC6VSWWJ98T66TGPSG97PPMH	pvps_01JC6VSY8V8SXPHTYZ65ZXGEQ3	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JC6VSD919HA7JS3T8EXZBSWX	pset_01JC6VSWWJ1QD5F3TBVMHX1646	pvps_01JC6VSY8VQD53Z2N48PF4CVB2	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JBYPBE94FG87CR5AG1W9E1Q9	pset_01JBYPBN468THKK67R9B1HNB99	pvps_01JBYPBPCVQTMX7DE9XG82Z3R6	2024-11-05 17:36:03+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
variant_01JBYPBE94W3J0DR77V2T1NRZD	pset_01JBYPBN47F2FPK47JMXS69BDW	pvps_01JBYPBPCWMT0TKR2SKJS2THKN	2024-11-05 17:36:03+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
variant_01JBYPBE94X1RY6QPC9D54E12H	pset_01JBYPBN47H115VYH3Y6B04GHJ	pvps_01JBYPBPCWDB0E3XHGC603WMCN	2024-11-05 17:36:03+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
variant_01JBYPBE95B901P7H677QKWZNW	pset_01JBYPBN48PFMTABKVTVQCE51B	pvps_01JBYPBPCWTQCP6SWJ3PJKB7DT	2024-11-05 17:36:03+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	pset_01JC6VSWWKBCQDF3WNV6WM2WQT	pvps_01JC6VSY8V7GC7W3GCX2V0XZZZ	2024-11-08 21:45:09+00	2024-11-08 21:45:09+00	\N
variant_01JBYPBE90Y0XBX14X6WRTQFRX	pset_01JBYPBN3ZSB5CDA2AKB0K1MTZ	pvps_01JBYPBPCSDV7SAVBV6080VSNB	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE918XY9ZYK9G7MNV363	pset_01JBYPBN3ZGA280M79TR4VNNNB	pvps_01JBYPBPCT73KTA8JZ6FE6MXX6	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE916PJQVRTYSQH4HPHN	pset_01JBYPBN40J76BT5CVPNF50850	pvps_01JBYPBPCTB9VKW2793WMPHQM1	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE91TCGBFJ0HECT809G1	pset_01JBYPBN40Y90Y5HDFE7F1GW0W	pvps_01JBYPBPCTYY52JHTSY712GBH4	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE921XBK4BG0NSA18CSC	pset_01JBYPBN4120ZEAQM70ZA752GZ	pvps_01JBYPBPCTJ77YQEJJG76M1BXB	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	pset_01JBYPBN41A6QJ0T0CHVS531JZ	pvps_01JBYPBPCTZAZFGVZW4WA7B97G	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE92CN934BR1AVBXK686	pset_01JBYPBN42GF6R89MHJ24NMBTK	pvps_01JBYPBPCTPF9K10TXBTQX9THD	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
variant_01JBYPBE92AWZRSMTER2T555QG	pset_01JBYPBN42C4Q3TE81PD4TS2SZ	pvps_01JBYPBPCT9NQ3EC34D7BC1CKB	2024-11-05 17:36:03+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
\.


--
-- TOC entry 4862 (class 0 OID 25193)
-- Dependencies: 244
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4863 (class 0 OID 25208)
-- Dependencies: 245
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- TOC entry 4860 (class 0 OID 25168)
-- Dependencies: 242
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4861 (class 0 OID 25179)
-- Dependencies: 243
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- TOC entry 4865 (class 0 OID 25237)
-- Dependencies: 247
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- TOC entry 4864 (class 0 OID 25225)
-- Dependencies: 246
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4868 (class 0 OID 25258)
-- Dependencies: 250
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4929 (class 0 OID 26292)
-- Dependencies: 311
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at) FROM stdin;
provid_01JBYPDQQN2F3V4T5WZAGP7Z8A	lopliok@gmail.com	emailpass	authid_01JBYPDQQPSG5JH0M4HRE2GMB8	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAYXV7lu9RmbhCZXdZ0ve2HMts8Nw/khPFe6YJEnHvpOfoKCoSMfMhkuiKGBtJLC7K8exV3WAI33BmWVryG+DIylu22LOJDZI/gMFdaZIZujq"}	2024-11-05 17:37:10.39+00	2024-11-05 17:37:10.39+00
provid_01JC1M2DX63XKVXZQ5W7S4KX46	test@gmail.com	emailpass	authid_01JC1M2DX70H1QK4D6G25HQM8E	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAZdcZdUeLuVce+PFwLj1/ZhabJ9/NoYUo8zO25Up7xHZRIttL4FtoGudo72eLwwbJ0NyI7lXZcjupp4JtonMu3fTgW+MaFvJ/UsZst9AfKLg"}	2024-11-06 20:53:46.023+00	2024-11-06 20:53:46.023+00
provid_01JC1MRK1QK0ZJNHWM3T1ZJYF7	lisan2167@gmail.com	emailpass	authid_01JC1MRK1QEFPYC37BQ3WM0PWY	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAaYna3Hqv+L7OZVwiCAjFtIfroYwBJ8tfhqJ545HdJRyyWPmQp1sXnZ/usOFAvI7mAVBpkzthYVoYJTWUMHJbde0x8CRylSj56tmKci5J3Fq"}	2024-11-06 21:05:52.183+00	2024-11-06 21:05:52.183+00
\.


--
-- TOC entry 4959 (class 0 OID 26703)
-- Dependencies: 341
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01JBYPASJ7CX64V2V1ST9YSV90	sc_01JBYPA6S9ZG068M4VFJQNC33B	pksc_01JBYPATBSRM36F5CDG3769VF8	2024-11-05 17:35:35+00	2024-11-05 17:35:35+00	\N
\.


--
-- TOC entry 4898 (class 0 OID 25750)
-- Dependencies: 280
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- TOC entry 4900 (class 0 OID 25809)
-- Dependencies: 282
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4882 (class 0 OID 25546)
-- Dependencies: 264
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01JBYPADWSXFGTDVY7VEGD8GDQ	Europe	eur	\N	2024-11-05 17:35:22.215+00	2024-11-05 17:35:22.215+00	\N	t
\.


--
-- TOC entry 4883 (class 0 OID 25557)
-- Dependencies: 265
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2024-11-05 17:34:57.723+00	2024-11-05 17:34:57.723+00	\N
al	alb	008	ALBANIA	Albania	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2024-11-05 17:34:57.725+00	2024-11-05 17:34:57.725+00	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
by	blr	112	BELARUS	Belarus	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bz	blz	084	BELIZE	Belize	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bj	ben	204	BENIN	Benin	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
ca	can	124	CANADA	Canada	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
td	tcd	148	CHAD	Chad	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cl	chl	152	CHILE	Chile	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cn	chn	156	CHINA	China	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
km	com	174	COMOROS	Comoros	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cg	cog	178	CONGO	Congo	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2024-11-05 17:34:57.726+00	2024-11-05 17:34:57.726+00	\N
cu	cub	192	CUBA	Cuba	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
fj	fji	242	FIJI	Fiji	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
fi	fin	246	FINLAND	Finland	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ga	gab	266	GABON	Gabon	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gh	gha	288	GHANA	Ghana	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gr	grc	300	GREECE	Greece	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gu	gum	316	GUAM	Guam	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ht	hti	332	HAITI	Haiti	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
is	isl	352	ICELAND	Iceland	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
in	ind	356	INDIA	India	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
il	isr	376	ISRAEL	Israel	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
je	jey	832	JERSEY	Jersey	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ke	ken	404	KENYA	Kenya	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:34:57.727+00	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ly	lby	434	LIBYA	Libya	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mo	mac	446	MACAO	Macao	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mk	mkd	807	MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF	Macedonia, the Former Yugoslav Republic of	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ml	mli	466	MALI	Mali	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mt	mlt	470	MALTA	Malta	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mc	mco	492	MONACO	Monaco	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nr	nru	520	NAURU	Nauru	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
np	npl	524	NEPAL	Nepal	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ne	ner	562	NIGER	Niger	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nu	niu	570	NIUE	Niue	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
no	nor	578	NORWAY	Norway	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
om	omn	512	OMAN	Oman	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pw	plw	585	PALAU	Palau	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pa	pan	591	PANAMA	Panama	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pe	per	604	PERU	Peru	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pl	pol	616	POLAND	Poland	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
qa	qat	634	QATAR	Qatar	\N	\N	2024-11-05 17:34:57.728+00	2024-11-05 17:34:57.728+00	\N
re	reu	638	REUNION	Reunion	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
so	som	706	SOMALIA	Somalia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
th	tha	764	THAILAND	Thailand	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tg	tgo	768	TOGO	Togo	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
to	ton	776	TONGA	Tonga	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
us	usa	840	UNITED STATES	United States	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:34:57.729+00	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2024-11-05 17:34:57.73+00	2024-11-05 17:34:57.73+00	\N
dk	dnk	208	DENMARK	Denmark	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:35:22.588+00	\N
fr	fra	250	FRANCE	France	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:35:22.588+00	\N
de	deu	276	GERMANY	Germany	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:35:22.588+00	\N
it	ita	380	ITALY	Italy	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.727+00	2024-11-05 17:35:22.588+00	\N
es	esp	724	SPAIN	Spain	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:35:22.588+00	\N
se	swe	752	SWEDEN	Sweden	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:35:22.588+00	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.729+00	2024-11-05 17:35:22.588+00	\N
\.


--
-- TOC entry 4962 (class 0 OID 26738)
-- Dependencies: 344
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01JBYPADWSXFGTDVY7VEGD8GDQ	pp_system_default	regpp_01JBYPAFFZCBBART4RZJ69E4K7	2024-11-05 17:35:23+00	2024-11-05 17:35:23+00	\N
\.


--
-- TOC entry 4840 (class 0 OID 24650)
-- Dependencies: 222
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
resitem_01JC1NZPG7J41K2QGCAXF53RK3	2024-11-06 21:27:13.862+00	2024-11-08 22:17:36.718+00	2024-11-08 22:17:30.584+00	ordli_01JC1NZH288S4WS3MJ4RG4FP3X	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	2	\N	\N	\N	\N	iitem_01JBYPBK4SQPXQPEXZJBRG4VPC	f	{"value": "2", "precision": 20}
resitem_01JC1NZPG7AB052ZR4CMBT2N17	2024-11-06 21:27:13.862+00	2024-11-08 22:17:41.097+00	2024-11-08 22:17:30.584+00	ordli_01JC1NZH28MV8MKF2EYK723HMN	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1	\N	\N	\N	\N	iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS	f	{"value": "1", "precision": 20}
\.


--
-- TOC entry 4919 (class 0 OID 26126)
-- Dependencies: 301
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- TOC entry 4956 (class 0 OID 26678)
-- Dependencies: 338
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4920 (class 0 OID 26141)
-- Dependencies: 302
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- TOC entry 4917 (class 0 OID 26020)
-- Dependencies: 299
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- TOC entry 4873 (class 0 OID 25389)
-- Dependencies: 255
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01JBYPA6S9ZG068M4VFJQNC33B	Default Sales Channel	Created by Medusa	f	\N	2024-11-05 17:35:14.729+00	2024-11-05 17:35:14.73+00	\N
\.


--
-- TOC entry 4961 (class 0 OID 26724)
-- Dependencies: 343
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01JBYPA6S9ZG068M4VFJQNC33B	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	scloc_01JBYPARZZZDFZYGB6WJRDN6F0	2024-11-05 17:35:33+00	2024-11-05 17:35:33+00	\N
\.


--
-- TOC entry 4935 (class 0 OID 26364)
-- Dependencies: 317
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01JBYPAJPF5JJQD2G692VYJY3F	Europe	\N	fuset_01JBYPAJPFXBEPZA9QMJZEE55N	2024-11-05 17:35:26.928+00	2024-11-05 17:35:26.928+00	\N
\.


--
-- TOC entry 4939 (class 0 OID 26413)
-- Dependencies: 321
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01JBYPANQPHC24PMZKPRMX0FRG	Standard Shipping	flat	serzo_01JBYPAJPF5JJQD2G692VYJY3F	sp_01JBYPAJ3696BYX7PWFDW67YPJ	manual_manual	\N	\N	sotype_01JBYPANQMCBWXCPXE7D18V3PB	2024-11-05 17:35:30.039+00	2024-11-05 17:35:30.039+00	\N
so_01JBYPANQQ3Z5W0C1FCWNESSJX	Express Shipping	flat	serzo_01JBYPAJPF5JJQD2G692VYJY3F	sp_01JBYPAJ3696BYX7PWFDW67YPJ	manual_manual	\N	\N	sotype_01JBYPANQP6TKKEZ6GC16V1R8W	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- TOC entry 4963 (class 0 OID 26786)
-- Dependencies: 345
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01JBYPANQPHC24PMZKPRMX0FRG	pset_01JBYPAPZ2HAEWHH400PK8M6GF	sops_01JBYPARCR4SY85WZK56ZNH244	2024-11-05 17:35:32+00	2024-11-05 17:35:32+00	\N
so_01JBYPANQQ3Z5W0C1FCWNESSJX	pset_01JBYPAPZ336WJ0KEYPADK7KMW	sops_01JBYPARCSXKNYRGAB01QAAAGF	2024-11-05 17:35:32+00	2024-11-05 17:35:32+00	\N
\.


--
-- TOC entry 4940 (class 0 OID 26433)
-- Dependencies: 322
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01JBYPANQNZHG8EMVHG0JPKXWJ	enabled_in_store	eq	"\\"true\\""	so_01JBYPANQPHC24PMZKPRMX0FRG	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPGTX4R1SB6G851BJT	is_return	eq	"\\"false\\""	so_01JBYPANQPHC24PMZKPRMX0FRG	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPDQ7V4DDVFJE0FMWD	enabled_in_store	eq	"\\"true\\""	so_01JBYPANQQ3Z5W0C1FCWNESSJX	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPCKC8Q2BCA9EP9CCB	is_return	eq	"\\"false\\""	so_01JBYPANQQ3Z5W0C1FCWNESSJX	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- TOC entry 4937 (class 0 OID 26392)
-- Dependencies: 319
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01JBYPANQMCBWXCPXE7D18V3PB	Standard	Ship in 2-3 days.	standard	2024-11-05 17:35:30.039+00	2024-11-05 17:35:30.039+00	\N
sotype_01JBYPANQP6TKKEZ6GC16V1R8W	Express	Ship in 24 hours.	express	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- TOC entry 4938 (class 0 OID 26402)
-- Dependencies: 320
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01JBYPAJ3696BYX7PWFDW67YPJ	Default	default	\N	2024-11-05 17:35:26.311+00	2024-11-05 17:35:26.311+00	\N
\.


--
-- TOC entry 4837 (class 0 OID 24608)
-- Dependencies: 219
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	2024-11-05 17:35:24.877+00	2024-11-05 17:35:24.877+00	\N	European Warehouse	laddr_01JBYPAGPC1A9VJQX7M7KB5190	\N
\.


--
-- TOC entry 4836 (class 0 OID 24598)
-- Dependencies: 218
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01JBYPAGPC1A9VJQX7M7KB5190	2024-11-05 17:35:24.877+00	2024-11-05 17:35:24.877+00	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- TOC entry 4885 (class 0 OID 25583)
-- Dependencies: 267
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01JBYPA7JD468QVY91ZAGTD63M	Medusa Store	sc_01JBYPA6S9ZG068M4VFJQNC33B	\N	\N	\N	2024-11-05 17:35:15.284367+00	2024-11-05 17:35:15.284367+00	\N
\.


--
-- TOC entry 4886 (class 0 OID 25595)
-- Dependencies: 268
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01JBYPAB0WJ612VBPH0YJC1RTE	eur	t	store_01JBYPA7JD468QVY91ZAGTD63M	2024-11-05 17:35:18.460098+00	2024-11-05 17:35:18.460098+00	\N
stocur_01JBYPAB0WZT65QYTTKQ7GX7G0	usd	f	store_01JBYPA7JD468QVY91ZAGTD63M	2024-11-05 17:35:18.460098+00	2024-11-05 17:35:18.460098+00	\N
\.


--
-- TOC entry 4887 (class 0 OID 25611)
-- Dependencies: 269
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_provider (id, is_enabled) FROM stdin;
\.


--
-- TOC entry 4889 (class 0 OID 25633)
-- Dependencies: 271
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- TOC entry 4890 (class 0 OID 25647)
-- Dependencies: 272
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- TOC entry 4888 (class 0 OID 25619)
-- Dependencies: 270
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01JBYPAG0ZD7ZAHYHJN1F8W1Q6	\N	gb	\N	\N	\N	2024-11-05 17:35:24.192+00	2024-11-05 17:35:24.192+00	\N	\N
txreg_01JBYPAG0Z2CB83GPDS7R26PFP	\N	de	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG0ZWQ2HAPCBQWJT0C28	\N	dk	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG0ZC4K5H76BZJ7E3C7P	\N	se	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG10M678KBBM68NDKPNJ	\N	fr	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG10HBTXA3892RM47HJS	\N	es	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG1061HZ57H3DPZPMQAM	\N	it	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
\.


--
-- TOC entry 4931 (class 0 OID 26323)
-- Dependencies: 313
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01JBYPDPWY9M4V4V7QJ4VA9MWY	\N	\N	lopliok@gmail.com	\N	\N	2024-11-05 17:37:09.534+00	2024-11-05 17:37:09.534+00	\N
user_01JC1M2CNDN7FVRRTTPVZGFMV7	\N	\N	test@gmail.com	\N	\N	2024-11-06 20:53:44.749+00	2024-11-06 20:53:44.75+00	\N
user_01JC1MRHV9WPHAPYNQAAY41VY2	\N	\N	lisan2167@gmail.com	\N	\N	2024-11-06 21:05:50.953+00	2024-11-06 21:05:50.954+00	\N
\.


--
-- TOC entry 4835 (class 0 OID 24585)
-- Dependencies: 217
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at) FROM stdin;
wf_exec_01JC1NZ2NA2TYKBN1933SXA75Q	complete-cart	cart_01JC1NQ4J2644QFB9G7YBQE3YG	{"state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-query"]}, "_root.use-query": {"id": "_root.use-query", "next": ["_root.use-query.use-remote-query"], "uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928415299, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "action": "use-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928415299, "saveResponse": true}, "_root.use-query.use-remote-query": {"id": "_root.use-query.use-remote-query", "next": ["_root.use-query.use-remote-query.validate-cart-payments"], "uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928416630, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928416630, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments": {"id": "_root.use-query.use-remote-query.validate-cart-payments", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step"], "uuid": "01JC1MVE96XWDW8476NX7T477J", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928421443, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96XWDW8476NX7T477J", "action": "validate-cart-payments", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928421443, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders"], "uuid": "01JC1MVE96AZJS497E7EQBTDVB", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928423286, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96AZJS497E7EQBTDVB", "action": "authorize-payment-session-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928423286, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step"], "uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928427791, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "action": "create-orders", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928427791, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts", "next": [], "uuid": "01JC1MVE971X9YMYV376K7K44S", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE971X9YMYV376K7K44S", "action": "update-carts", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage"], "uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "action": "emit-event-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links", "next": [], "uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "action": "create-remote-links", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step", "next": [], "uuid": "01JC1MVE971573931TM0HBS949", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE971573931TM0HBS949", "action": "reserve-inventory-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39"], "uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "depth": 7, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928435882, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "action": "register-usage", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928435882, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39", "next": [], "uuid": "01JC1MVE97SCZWDSGY96584T32", "depth": 8, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928437725, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97SCZWDSGY96584T32", "action": "when-then-01JC1MVE97GG292XVVPGAE1N39", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928437725, "saveResponse": true}}, "modelId": "complete-cart", "options": {"name": "complete-cart", "store": true, "idempotent": true, "retentionTime": 259200, "storeExecution": true}, "metadata": {"sourcePath": "/home/liza/projects/personal/flowers_e-commerce/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/complete-cart.js", "eventGroupId": "01JC1NZ225ZJ4VNW8WZEEABEQ3"}, "startedAt": 1730928414070, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "action": "create-remote-links", "noCompensation": false}, {"uuid": "01JC1MVE971X9YMYV376K7K44S", "action": "update-carts", "noCompensation": false}, {"uuid": "01JC1MVE971573931TM0HBS949", "action": "reserve-inventory-step", "noCompensation": false}, {"next": {"next": {"uuid": "01JC1MVE97SCZWDSGY96584T32", "action": "when-then-01JC1MVE97GG292XVVPGAE1N39", "noCompensation": true}, "uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "action": "register-usage", "noCompensation": false}, "uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "action": "emit-event-step", "noCompensation": false}], "uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "action": "create-orders", "noCompensation": false}, "uuid": "01JC1MVE96AZJS497E7EQBTDVB", "action": "authorize-payment-session-step", "noCompensation": false}, "uuid": "01JC1MVE96XWDW8476NX7T477J", "action": "validate-cart-payments", "noCompensation": true}, "uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "action": "use-remote-query", "noCompensation": true}, "uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "action": "use-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"use-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": []}, "compensateInput": {"data": []}}}, "update-carts": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:22:33.154Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:13.857Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": "2024-11-06T21:27:12.303Z", "currency_code": "eur", "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}, "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}], "compensateInput": [{"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "completed_at": null}]}}, "create-orders": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}], "compensateInput": ["order_01JC1NZH27XD1DJ2Q134XE9PXC"]}}, "register-usage": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": []}}, "emit-event-step": {"__type": "Symbol(WorkflowWorkflowData)"}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "items": [{"id": "cali_01JC1NQNN7QHZWRC46VSPH20P9", "title": "M / Black", "total": 20, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:22:50.664Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "20", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 20, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}, {"id": "cali_01JC1NSRFMWADF62NXS0VYWTR3", "title": "S / Black", "total": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:23:59.093Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "S / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 40, "region": {"id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "name": "Europe", "metadata": null, "created_at": "2024-11-05T17:35:22.215Z", "deleted_at": null, "updated_at": "2024-11-05T17:35:22.215Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "email": "hml-tester@hml.cz", "phone": null, "metadata": null, "last_name": null, "created_at": "2024-11-06T21:24:45.632Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2024-11-06T21:24:45.632Z", "has_account": false, "company_name": null}, "subtotal": 40, "raw_total": {"value": "40", "precision": 20}, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "tax_total": 0, "created_at": "2024-11-06T21:22:33.154Z", "item_total": 30, "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": null, "raw_subtotal": {"value": "40", "precision": 20}, "currency_code": "eur", "item_subtotal": 30, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 40, "raw_item_total": {"value": "30", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "casm_01JC1NWJ64JXNHWWPZJ29BYWYT", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2024-11-06T21:25:30.948Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:25:36.450Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "30", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "not_paid", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:23.587Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "40", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 30, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 30, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "30", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "30", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}, "compensateInput": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "items": [{"id": "cali_01JC1NQNN7QHZWRC46VSPH20P9", "title": "M / Black", "total": 20, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:22:50.664Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "20", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 20, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}, {"id": "cali_01JC1NSRFMWADF62NXS0VYWTR3", "title": "S / Black", "total": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:23:59.093Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "S / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 40, "region": {"id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "name": "Europe", "metadata": null, "created_at": "2024-11-05T17:35:22.215Z", "deleted_at": null, "updated_at": "2024-11-05T17:35:22.215Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "email": "hml-tester@hml.cz", "phone": null, "metadata": null, "last_name": null, "created_at": "2024-11-06T21:24:45.632Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2024-11-06T21:24:45.632Z", "has_account": false, "company_name": null}, "subtotal": 40, "raw_total": {"value": "40", "precision": 20}, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "tax_total": 0, "created_at": "2024-11-06T21:22:33.154Z", "item_total": 30, "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": null, "raw_subtotal": {"value": "40", "precision": 20}, "currency_code": "eur", "item_subtotal": 30, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 40, "raw_item_total": {"value": "30", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "casm_01JC1NWJ64JXNHWWPZJ29BYWYT", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2024-11-06T21:25:30.948Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:25:36.450Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "30", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "not_paid", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:23.587Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "40", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 30, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 30, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "30", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "30", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}}}, "create-remote-links": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"cart": {"cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}}, {"order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}, "payment": {"payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}], "compensateInput": [{"cart": {"cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}}, {"order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}, "payment": {"payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}]}}, "reserve-inventory-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "resitem_01JC1NZPG7J41K2QGCAXF53RK3", "metadata": null, "quantity": 2, "created_at": "2024-11-06T21:27:13.862Z", "created_by": null, "deleted_at": null, "updated_at": "2024-11-06T21:27:13.862Z", "description": null, "external_id": null, "location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "line_item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "raw_quantity": {"value": "2", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC"}, {"id": "resitem_01JC1NZPG7AB052ZR4CMBT2N17", "metadata": null, "quantity": 1, "created_at": "2024-11-06T21:27:13.862Z", "created_by": null, "deleted_at": null, "updated_at": "2024-11-06T21:27:13.862Z", "description": null, "external_id": null, "location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "line_item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "raw_quantity": {"value": "1", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS"}], "compensateInput": {"reservations": ["resitem_01JC1NZPG7J41K2QGCAXF53RK3", "resitem_01JC1NZPG7AB052ZR4CMBT2N17"], "inventoryItemIds": ["iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS"]}}}, "validate-cart-payments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "compensateInput": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}]}}, "authorize-payment-session-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "pay_01JC1NZD0TAH7A0SSMYA0MHMCM", "data": {}, "amount": 40, "cart_id": null, "refunds": [], "captures": [], "metadata": null, "order_id": null, "created_at": "2024-11-06T21:27:03.962Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.962Z", "canceled_at": null, "captured_at": null, "customer_id": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_session": {"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "compensateInput": {"id": "pay_01JC1NZD0TAH7A0SSMYA0MHMCM", "data": {}, "amount": 40, "cart_id": null, "refunds": [], "captures": [], "metadata": null, "order_id": null, "created_at": "2024-11-06T21:27:03.962Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.962Z", "canceled_at": null, "captured_at": null, "customer_id": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_session": {"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}}, "when-then-01JC1MVE97GG292XVVPGAE1N39": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}, "compensateInput": {"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}}}}, "payload": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "compensate": {}}, "errors": []}	done	2024-11-06 21:26:53.354	2024-11-06 21:27:20.232	\N
\.


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 328
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 32, true);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 215
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 58, true);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 288
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 306
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 284
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, true);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 303
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 300
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- TOC entry 4152 (class 2606 OID 25207)
-- Name: promotion IDX_promotion_code_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT "IDX_promotion_code_unique" UNIQUE (code);


--
-- TOC entry 4044 (class 2606 OID 24593)
-- Name: workflow_execution PK_workflow_execution_workflow_id_transaction_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT "PK_workflow_execution_workflow_id_transaction_id" PRIMARY KEY (workflow_id, transaction_id);


--
-- TOC entry 4248 (class 2606 OID 25579)
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- TOC entry 4173 (class 2606 OID 25257)
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- TOC entry 4171 (class 2606 OID 25250)
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- TOC entry 4429 (class 2606 OID 26289)
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- TOC entry 4306 (class 2606 OID 25767)
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- TOC entry 4207 (class 2606 OID 25423)
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4218 (class 2606 OID 25459)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 4213 (class 2606 OID 25436)
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 25470)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 4518 (class 2606 OID 26600)
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- TOC entry 4204 (class 2606 OID 25408)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 4524 (class 2606 OID 26613)
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- TOC entry 4233 (class 2606 OID 25494)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 4228 (class 2606 OID 25483)
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- TOC entry 4238 (class 2606 OID 25505)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 25692)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- TOC entry 4184 (class 2606 OID 25347)
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4192 (class 2606 OID 25369)
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- TOC entry 4188 (class 2606 OID 25359)
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4179 (class 2606 OID 25336)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 4445 (class 2606 OID 26343)
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4489 (class 2606 OID 26455)
-- Name: fulfillment fulfillment_delivery_address_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_unique UNIQUE (delivery_address_id);


--
-- TOC entry 4501 (class 2606 OID 26479)
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4495 (class 2606 OID 26468)
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- TOC entry 4491 (class 2606 OID 26453)
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- TOC entry 4447 (class 2606 OID 26352)
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 4451 (class 2606 OID 26361)
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- TOC entry 4463 (class 2606 OID 26386)
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- TOC entry 4092 (class 2606 OID 24785)
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- TOC entry 4054 (class 2606 OID 24632)
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4060 (class 2606 OID 24646)
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- TOC entry 4438 (class 2606 OID 26319)
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- TOC entry 4510 (class 2606 OID 26589)
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4512 (class 2606 OID 26591)
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- TOC entry 4530 (class 2606 OID 26626)
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- TOC entry 4536 (class 2606 OID 26639)
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- TOC entry 4038 (class 2606 OID 24584)
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4508 (class 2606 OID 26563)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 4503 (class 2606 OID 26555)
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 4311 (class 2606 OID 25834)
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4542 (class 2606 OID 26652)
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- TOC entry 4344 (class 2606 OID 25914)
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- TOC entry 4335 (class 2606 OID 25899)
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- TOC entry 4427 (class 2606 OID 26234)
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- TOC entry 4423 (class 2606 OID 26222)
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4418 (class 2606 OID 26199)
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- TOC entry 4412 (class 2606 OID 26179)
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4407 (class 2606 OID 26166)
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- TOC entry 4548 (class 2606 OID 26680)
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- TOC entry 4350 (class 2606 OID 25926)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4369 (class 2606 OID 25974)
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 4363 (class 2606 OID 25953)
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4366 (class 2606 OID 25964)
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 4554 (class 2606 OID 26725)
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- TOC entry 4321 (class 2606 OID 25848)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 4560 (class 2606 OID 26709)
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- TOC entry 4375 (class 2606 OID 25995)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- TOC entry 4372 (class 2606 OID 25985)
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- TOC entry 4378 (class 2606 OID 26005)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- TOC entry 4359 (class 2606 OID 25938)
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- TOC entry 4325 (class 2606 OID 25887)
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- TOC entry 4386 (class 2606 OID 26016)
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 4286 (class 2606 OID 25729)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- TOC entry 4279 (class 2606 OID 25705)
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- TOC entry 4282 (class 2606 OID 25714)
-- Name: payment_method_token payment_method_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method_token
    ADD CONSTRAINT payment_method_token_pkey PRIMARY KEY (id);


--
-- TOC entry 4296 (class 2606 OID 25823)
-- Name: payment payment_payment_session_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_session_id_unique UNIQUE (payment_session_id);


--
-- TOC entry 4298 (class 2606 OID 25749)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 25722)
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 4290 (class 2606 OID 25740)
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 25060)
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 25069)
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 4126 (class 2606 OID 24984)
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 25165)
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 25015)
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 4120 (class 2606 OID 24974)
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 24833)
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 24857)
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- TOC entry 4105 (class 2606 OID 24818)
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 24850)
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (product_id, image_id);


--
-- TOC entry 4084 (class 2606 OID 24763)
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- TOC entry 4088 (class 2606 OID 24774)
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- TOC entry 4072 (class 2606 OID 24732)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 4590 (class 2606 OID 26746)
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- TOC entry 4096 (class 2606 OID 24796)
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- TOC entry 4111 (class 2606 OID 24843)
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- TOC entry 4100 (class 2606 OID 24807)
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4572 (class 2606 OID 26722)
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- TOC entry 4117 (class 2606 OID 24864)
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- TOC entry 4080 (class 2606 OID 24748)
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- TOC entry 4578 (class 2606 OID 26726)
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- TOC entry 4161 (class 2606 OID 25219)
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- TOC entry 4163 (class 2606 OID 25224)
-- Name: promotion_application_method promotion_application_method_promotion_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_unique UNIQUE (promotion_id);


--
-- TOC entry 4147 (class 2606 OID 25192)
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_unique UNIQUE (campaign_id);


--
-- TOC entry 4149 (class 2606 OID 25189)
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 25176)
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- TOC entry 4155 (class 2606 OID 25203)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- TOC entry 4169 (class 2606 OID 25243)
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- TOC entry 4167 (class 2606 OID 25234)
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 4176 (class 2606 OID 25266)
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- TOC entry 4433 (class 2606 OID 26300)
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- TOC entry 4584 (class 2606 OID 26732)
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- TOC entry 4302 (class 2606 OID 25758)
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- TOC entry 4308 (class 2606 OID 25817)
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 4244 (class 2606 OID 25563)
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- TOC entry 4602 (class 2606 OID 26756)
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- TOC entry 4241 (class 2606 OID 25554)
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- TOC entry 4066 (class 2606 OID 24658)
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4566 (class 2606 OID 26729)
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- TOC entry 4401 (class 2606 OID 26150)
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4395 (class 2606 OID 26136)
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 26028)
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 4195 (class 2606 OID 25398)
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- TOC entry 4596 (class 2606 OID 26751)
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- TOC entry 4456 (class 2606 OID 26372)
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- TOC entry 4477 (class 2606 OID 26423)
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- TOC entry 4608 (class 2606 OID 26796)
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- TOC entry 4483 (class 2606 OID 26442)
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 4479 (class 2606 OID 26427)
-- Name: shipping_option shipping_option_shipping_option_type_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_unique UNIQUE (shipping_option_type_id);


--
-- TOC entry 4466 (class 2606 OID 26400)
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4470 (class 2606 OID 26410)
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- TOC entry 4047 (class 2606 OID 24606)
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4050 (class 2606 OID 24616)
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- TOC entry 4254 (class 2606 OID 25604)
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 25593)
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- TOC entry 4256 (class 2606 OID 25618)
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- TOC entry 4267 (class 2606 OID 25643)
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- TOC entry 4273 (class 2606 OID 25655)
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 25629)
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- TOC entry 4442 (class 2606 OID 26331)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 4214 (class 1259 OID 25460)
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4229 (class 1259 OID 25495)
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4245 (class 1259 OID 25580)
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- TOC entry 4246 (class 1259 OID 25581)
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- TOC entry 4156 (class 1259 OID 25222)
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- TOC entry 4157 (class 1259 OID 25221)
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- TOC entry 4158 (class 1259 OID 25220)
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- TOC entry 4145 (class 1259 OID 25190)
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- TOC entry 4303 (class 1259 OID 25824)
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- TOC entry 4304 (class 1259 OID 25776)
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4205 (class 1259 OID 25539)
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4196 (class 1259 OID 25411)
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- TOC entry 4197 (class 1259 OID 25414)
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- TOC entry 4198 (class 1259 OID 25409)
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- TOC entry 4199 (class 1259 OID 25538)
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4513 (class 1259 OID 26603)
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- TOC entry 4537 (class 1259 OID 26653)
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- TOC entry 4519 (class 1259 OID 26616)
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- TOC entry 4215 (class 1259 OID 25540)
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4208 (class 1259 OID 25545)
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4219 (class 1259 OID 25542)
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4200 (class 1259 OID 25412)
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- TOC entry 4201 (class 1259 OID 25413)
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- TOC entry 4202 (class 1259 OID 25410)
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- TOC entry 4230 (class 1259 OID 25541)
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4224 (class 1259 OID 25544)
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4234 (class 1259 OID 25543)
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4106 (class 1259 OID 24834)
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 4101 (class 1259 OID 24819)
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 4180 (class 1259 OID 25348)
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- TOC entry 4181 (class 1259 OID 25349)
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- TOC entry 4182 (class 1259 OID 25350)
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- TOC entry 4177 (class 1259 OID 25387)
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- TOC entry 4189 (class 1259 OID 25371)
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- TOC entry 4190 (class 1259 OID 25370)
-- Name: IDX_customer_group_customer_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id);


--
-- TOC entry 4185 (class 1259 OID 25360)
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4186 (class 1259 OID 25388)
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4579 (class 1259 OID 26781)
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- TOC entry 4525 (class 1259 OID 26630)
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- TOC entry 4561 (class 1259 OID 26780)
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- TOC entry 4514 (class 1259 OID 26604)
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- TOC entry 4538 (class 1259 OID 26656)
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- TOC entry 4555 (class 1259 OID 26771)
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- TOC entry 4520 (class 1259 OID 26617)
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- TOC entry 4531 (class 1259 OID 26643)
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- TOC entry 4543 (class 1259 OID 26765)
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- TOC entry 4567 (class 1259 OID 26778)
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- TOC entry 4597 (class 1259 OID 26794)
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- TOC entry 4585 (class 1259 OID 26785)
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- TOC entry 4591 (class 1259 OID 26793)
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- TOC entry 4573 (class 1259 OID 26784)
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- TOC entry 4603 (class 1259 OID 26800)
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- TOC entry 4549 (class 1259 OID 26777)
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- TOC entry 4443 (class 1259 OID 26344)
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4484 (class 1259 OID 26459)
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4562 (class 1259 OID 26757)
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- TOC entry 4544 (class 1259 OID 26702)
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- TOC entry 4496 (class 1259 OID 26483)
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4497 (class 1259 OID 26482)
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4498 (class 1259 OID 26481)
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4499 (class 1259 OID 26480)
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4492 (class 1259 OID 26470)
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4493 (class 1259 OID 26469)
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4485 (class 1259 OID 26456)
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4486 (class 1259 OID 26457)
-- Name: IDX_fulfillment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id" ON public.fulfillment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4526 (class 1259 OID 26627)
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- TOC entry 4448 (class 1259 OID 26363)
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4532 (class 1259 OID 26640)
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- TOC entry 4449 (class 1259 OID 26362)
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4487 (class 1259 OID 26458)
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4457 (class 1259 OID 26389)
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- TOC entry 4458 (class 1259 OID 26387)
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 4459 (class 1259 OID 26391)
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4460 (class 1259 OID 26388)
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- TOC entry 4461 (class 1259 OID 26390)
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4580 (class 1259 OID 26762)
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- TOC entry 4527 (class 1259 OID 26628)
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- TOC entry 4563 (class 1259 OID 26766)
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- TOC entry 4515 (class 1259 OID 26602)
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- TOC entry 4539 (class 1259 OID 26654)
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- TOC entry 4556 (class 1259 OID 26752)
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- TOC entry 4521 (class 1259 OID 26615)
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- TOC entry 4533 (class 1259 OID 26641)
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- TOC entry 4545 (class 1259 OID 26731)
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- TOC entry 4568 (class 1259 OID 26760)
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- TOC entry 4598 (class 1259 OID 26776)
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- TOC entry 4586 (class 1259 OID 26770)
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- TOC entry 4592 (class 1259 OID 26774)
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- TOC entry 4574 (class 1259 OID 26764)
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- TOC entry 4604 (class 1259 OID 26798)
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- TOC entry 4550 (class 1259 OID 26759)
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- TOC entry 4051 (class 1259 OID 24633)
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4569 (class 1259 OID 26747)
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- TOC entry 4052 (class 1259 OID 24714)
-- Name: IDX_inventory_item_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku_unique" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- TOC entry 4055 (class 1259 OID 24647)
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4056 (class 1259 OID 24715)
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4057 (class 1259 OID 24720)
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4058 (class 1259 OID 24716)
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4434 (class 1259 OID 26322)
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4435 (class 1259 OID 26320)
-- Name: IDX_invite_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_invite_email" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 4436 (class 1259 OID 26321)
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- TOC entry 4216 (class 1259 OID 25461)
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- TOC entry 4209 (class 1259 OID 25447)
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4210 (class 1259 OID 25448)
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- TOC entry 4220 (class 1259 OID 25472)
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- TOC entry 4211 (class 1259 OID 25449)
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- TOC entry 4504 (class 1259 OID 26576)
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- TOC entry 4505 (class 1259 OID 26564)
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- TOC entry 4506 (class 1259 OID 26566)
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- TOC entry 4081 (class 1259 OID 24764)
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- TOC entry 4085 (class 1259 OID 24775)
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 4309 (class 1259 OID 25835)
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- TOC entry 4312 (class 1259 OID 25875)
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4336 (class 1259 OID 26113)
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4337 (class 1259 OID 26111)
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- TOC entry 4338 (class 1259 OID 26114)
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4339 (class 1259 OID 25915)
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- TOC entry 4340 (class 1259 OID 25916)
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- TOC entry 4341 (class 1259 OID 25917)
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- TOC entry 4342 (class 1259 OID 26112)
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4326 (class 1259 OID 26100)
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- TOC entry 4327 (class 1259 OID 26109)
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4328 (class 1259 OID 26101)
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- TOC entry 4329 (class 1259 OID 26110)
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4330 (class 1259 OID 25900)
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- TOC entry 4331 (class 1259 OID 25901)
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- TOC entry 4332 (class 1259 OID 26108)
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4333 (class 1259 OID 25902)
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- TOC entry 4413 (class 1259 OID 26201)
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 4414 (class 1259 OID 26200)
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4419 (class 1259 OID 26224)
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4420 (class 1259 OID 26223)
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 4424 (class 1259 OID 26235)
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4425 (class 1259 OID 26236)
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4421 (class 1259 OID 26225)
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4415 (class 1259 OID 26202)
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4416 (class 1259 OID 26203)
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4313 (class 1259 OID 25873)
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 4314 (class 1259 OID 25872)
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4315 (class 1259 OID 25876)
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- TOC entry 4316 (class 1259 OID 25870)
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4402 (class 1259 OID 26168)
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 4403 (class 1259 OID 26167)
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4408 (class 1259 OID 26180)
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 4409 (class 1259 OID 26181)
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4410 (class 1259 OID 26182)
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4404 (class 1259 OID 26169)
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4405 (class 1259 OID 26170)
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4540 (class 1259 OID 26655)
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- TOC entry 4557 (class 1259 OID 26763)
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- TOC entry 4546 (class 1259 OID 26753)
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- TOC entry 4551 (class 1259 OID 26768)
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- TOC entry 4317 (class 1259 OID 25877)
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- TOC entry 4345 (class 1259 OID 26276)
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4346 (class 1259 OID 25929)
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4347 (class 1259 OID 25927)
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4348 (class 1259 OID 25928)
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 4367 (class 1259 OID 26243)
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4360 (class 1259 OID 26239)
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4364 (class 1259 OID 26242)
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4361 (class 1259 OID 26238)
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4318 (class 1259 OID 25871)
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4319 (class 1259 OID 25874)
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4351 (class 1259 OID 26106)
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4352 (class 1259 OID 26278)
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4353 (class 1259 OID 26107)
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4354 (class 1259 OID 25941)
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4373 (class 1259 OID 26241)
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4370 (class 1259 OID 26237)
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4376 (class 1259 OID 26240)
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4355 (class 1259 OID 25939)
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4356 (class 1259 OID 25940)
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 4357 (class 1259 OID 26105)
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4322 (class 1259 OID 26277)
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4323 (class 1259 OID 25888)
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 4379 (class 1259 OID 26103)
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4380 (class 1259 OID 26018)
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 4381 (class 1259 OID 26104)
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4382 (class 1259 OID 26017)
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- TOC entry 4383 (class 1259 OID 26019)
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4384 (class 1259 OID 26102)
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4276 (class 1259 OID 25773)
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4516 (class 1259 OID 26601)
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- TOC entry 4552 (class 1259 OID 26748)
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- TOC entry 4277 (class 1259 OID 25772)
-- Name: IDX_payment_collection_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_region_id" ON public.payment_collection USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4291 (class 1259 OID 25768)
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4280 (class 1259 OID 25770)
-- Name: IDX_payment_method_token_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_method_token_deleted_at" ON public.payment_method_token USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4292 (class 1259 OID 25769)
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4293 (class 1259 OID 25821)
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- TOC entry 4294 (class 1259 OID 25771)
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4599 (class 1259 OID 26761)
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- TOC entry 4287 (class 1259 OID 25820)
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- TOC entry 4288 (class 1259 OID 25778)
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4121 (class 1259 OID 25145)
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 4122 (class 1259 OID 25105)
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4131 (class 1259 OID 25100)
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4134 (class 1259 OID 25117)
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4135 (class 1259 OID 25116)
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4138 (class 1259 OID 25167)
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- TOC entry 4139 (class 1259 OID 25166)
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4123 (class 1259 OID 25104)
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4124 (class 1259 OID 25102)
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4127 (class 1259 OID 25114)
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4128 (class 1259 OID 25155)
-- Name: IDX_price_rule_price_id_attribute_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_unique" ON public.price_rule USING btree (price_id, attribute) WHERE (deleted_at IS NULL);


--
-- TOC entry 4118 (class 1259 OID 25101)
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4575 (class 1259 OID 26754)
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- TOC entry 4605 (class 1259 OID 26797)
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- TOC entry 4102 (class 1259 OID 24836)
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- TOC entry 4107 (class 1259 OID 24835)
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- TOC entry 4103 (class 1259 OID 24820)
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- TOC entry 4067 (class 1259 OID 24735)
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4068 (class 1259 OID 24736)
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- TOC entry 4069 (class 1259 OID 24733)
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- TOC entry 4587 (class 1259 OID 26779)
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- TOC entry 4089 (class 1259 OID 24787)
-- Name: IDX_product_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_deleted_at" ON public.image USING btree (deleted_at);


--
-- TOC entry 4090 (class 1259 OID 24786)
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- TOC entry 4082 (class 1259 OID 24765)
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- TOC entry 4086 (class 1259 OID 24776)
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- TOC entry 4093 (class 1259 OID 24798)
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- TOC entry 4097 (class 1259 OID 24809)
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- TOC entry 4070 (class 1259 OID 24734)
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4073 (class 1259 OID 24752)
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- TOC entry 4074 (class 1259 OID 24754)
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- TOC entry 4075 (class 1259 OID 24749)
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- TOC entry 4076 (class 1259 OID 24753)
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4077 (class 1259 OID 24751)
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- TOC entry 4078 (class 1259 OID 24750)
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- TOC entry 4159 (class 1259 OID 25325)
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4142 (class 1259 OID 25326)
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- TOC entry 4150 (class 1259 OID 25204)
-- Name: IDX_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_code" ON public.promotion USING btree (code);


--
-- TOC entry 4558 (class 1259 OID 26737)
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- TOC entry 4522 (class 1259 OID 26614)
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- TOC entry 4164 (class 1259 OID 25235)
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- TOC entry 4165 (class 1259 OID 25236)
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- TOC entry 4174 (class 1259 OID 25267)
-- Name: IDX_promotion_rule_promotion_rule_value_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_promotion_rule_value_id" ON public.promotion_rule_value USING btree (promotion_rule_id);


--
-- TOC entry 4153 (class 1259 OID 25205)
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- TOC entry 4430 (class 1259 OID 26301)
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- TOC entry 4431 (class 1259 OID 26302)
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- TOC entry 4581 (class 1259 OID 26773)
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- TOC entry 4299 (class 1259 OID 25825)
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- TOC entry 4300 (class 1259 OID 25774)
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4242 (class 1259 OID 25564)
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- TOC entry 4239 (class 1259 OID 25556)
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4600 (class 1259 OID 26782)
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- TOC entry 4061 (class 1259 OID 24660)
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4062 (class 1259 OID 24719)
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4063 (class 1259 OID 24717)
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4064 (class 1259 OID 24718)
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4390 (class 1259 OID 26138)
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4391 (class 1259 OID 26140)
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4392 (class 1259 OID 26139)
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4564 (class 1259 OID 26775)
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- TOC entry 4396 (class 1259 OID 26151)
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- TOC entry 4397 (class 1259 OID 26153)
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4398 (class 1259 OID 26154)
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4399 (class 1259 OID 26152)
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4393 (class 1259 OID 26137)
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4387 (class 1259 OID 26034)
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 4193 (class 1259 OID 25399)
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- TOC entry 4582 (class 1259 OID 26749)
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- TOC entry 4588 (class 1259 OID 26758)
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- TOC entry 4593 (class 1259 OID 26783)
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- TOC entry 4452 (class 1259 OID 26375)
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4453 (class 1259 OID 26374)
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4454 (class 1259 OID 26373)
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4231 (class 1259 OID 25496)
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- TOC entry 4225 (class 1259 OID 25484)
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4226 (class 1259 OID 25485)
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- TOC entry 4235 (class 1259 OID 25507)
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- TOC entry 4471 (class 1259 OID 26432)
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4606 (class 1259 OID 26799)
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- TOC entry 4472 (class 1259 OID 26430)
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4480 (class 1259 OID 26444)
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4481 (class 1259 OID 26443)
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4473 (class 1259 OID 26428)
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4474 (class 1259 OID 26431)
-- Name: IDX_shipping_option_shipping_option_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_option_type_id" ON public.shipping_option USING btree (shipping_option_type_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4475 (class 1259 OID 26429)
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4464 (class 1259 OID 26401)
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4467 (class 1259 OID 26412)
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4468 (class 1259 OID 26411)
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4263 (class 1259 OID 25646)
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- TOC entry 4045 (class 1259 OID 24607)
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4048 (class 1259 OID 24617)
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4528 (class 1259 OID 26629)
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- TOC entry 4534 (class 1259 OID 26642)
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- TOC entry 4594 (class 1259 OID 26767)
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- TOC entry 4252 (class 1259 OID 25605)
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4249 (class 1259 OID 25594)
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4094 (class 1259 OID 24797)
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 4221 (class 1259 OID 25471)
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4236 (class 1259 OID 25506)
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4264 (class 1259 OID 25645)
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4268 (class 1259 OID 25658)
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4269 (class 1259 OID 25657)
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4270 (class 1259 OID 25656)
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4271 (class 1259 OID 25659)
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4265 (class 1259 OID 25644)
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4257 (class 1259 OID 25631)
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4258 (class 1259 OID 25630)
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- TOC entry 4259 (class 1259 OID 25681)
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- TOC entry 4260 (class 1259 OID 25680)
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- TOC entry 4098 (class 1259 OID 24808)
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- TOC entry 4439 (class 1259 OID 26333)
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- TOC entry 4440 (class 1259 OID 26334)
-- Name: IDX_user_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_email" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- TOC entry 4570 (class 1259 OID 26769)
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- TOC entry 4576 (class 1259 OID 26772)
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- TOC entry 4039 (class 1259 OID 24594)
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id);


--
-- TOC entry 4040 (class 1259 OID 24597)
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- TOC entry 4041 (class 1259 OID 24596)
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4042 (class 1259 OID 24595)
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- TOC entry 4656 (class 2606 OID 25675)
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- TOC entry 4655 (class 2606 OID 25670)
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- TOC entry 4653 (class 2606 OID 25665)
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- TOC entry 4654 (class 2606 OID 25660)
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- TOC entry 4637 (class 2606 OID 25304)
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4638 (class 2606 OID 25309)
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4635 (class 2606 OID 25294)
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4636 (class 2606 OID 25299)
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4661 (class 2606 OID 25799)
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4643 (class 2606 OID 25442)
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4646 (class 2606 OID 25513)
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4645 (class 2606 OID 25508)
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4647 (class 2606 OID 25518)
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4644 (class 2606 OID 25437)
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4649 (class 2606 OID 25528)
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4648 (class 2606 OID 25523)
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4650 (class 2606 OID 25533)
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4640 (class 2606 OID 25372)
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4641 (class 2606 OID 25377)
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON DELETE CASCADE;


--
-- TOC entry 4642 (class 2606 OID 25382)
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- TOC entry 4684 (class 2606 OID 26529)
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4688 (class 2606 OID 26539)
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4687 (class 2606 OID 26534)
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4685 (class 2606 OID 26519)
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4686 (class 2606 OID 26524)
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4678 (class 2606 OID 26489)
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4610 (class 2606 OID 24664)
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4689 (class 2606 OID 26567)
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4662 (class 2606 OID 26040)
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4665 (class 2606 OID 26050)
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4664 (class 2606 OID 26045)
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4666 (class 2606 OID 26060)
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4667 (class 2606 OID 26055)
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4671 (class 2606 OID 26075)
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4670 (class 2606 OID 26070)
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4669 (class 2606 OID 26065)
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4663 (class 2606 OID 26035)
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4672 (class 2606 OID 26085)
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4673 (class 2606 OID 26090)
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4668 (class 2606 OID 26080)
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4674 (class 2606 OID 26095)
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4657 (class 2606 OID 25779)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_coll_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_coll_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4658 (class 2606 OID 25784)
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_provider_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_provider_id_foreig FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4659 (class 2606 OID 25794)
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4629 (class 2606 OID 25135)
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4626 (class 2606 OID 25120)
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4627 (class 2606 OID 25016)
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4628 (class 2606 OID 25146)
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4617 (class 2606 OID 24930)
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4622 (class 2606 OID 24925)
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4623 (class 2606 OID 24920)
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4612 (class 2606 OID 24865)
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4620 (class 2606 OID 24905)
-- Name: product_images product_images_image_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_image_id_foreign FOREIGN KEY (image_id) REFERENCES public.image(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4621 (class 2606 OID 24900)
-- Name: product_images product_images_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4615 (class 2606 OID 24880)
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4616 (class 2606 OID 24885)
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4618 (class 2606 OID 24910)
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4619 (class 2606 OID 24915)
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4613 (class 2606 OID 24870)
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4624 (class 2606 OID 24895)
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4625 (class 2606 OID 24890)
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4614 (class 2606 OID 24875)
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4632 (class 2606 OID 25278)
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4630 (class 2606 OID 25268)
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE;


--
-- TOC entry 4631 (class 2606 OID 25319)
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4633 (class 2606 OID 25283)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4634 (class 2606 OID 25289)
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4639 (class 2606 OID 25314)
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4676 (class 2606 OID 26303)
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4660 (class 2606 OID 25804)
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4651 (class 2606 OID 25565)
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4611 (class 2606 OID 24669)
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4675 (class 2606 OID 26029)
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- TOC entry 4677 (class 2606 OID 26484)
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4679 (class 2606 OID 26504)
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4683 (class 2606 OID 26514)
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4680 (class 2606 OID 26494)
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4681 (class 2606 OID 26509)
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4682 (class 2606 OID 26499)
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4609 (class 2606 OID 24618)
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4652 (class 2606 OID 25606)
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-11-12 14:40:53 UTC

--
-- PostgreSQL database dump complete
--

