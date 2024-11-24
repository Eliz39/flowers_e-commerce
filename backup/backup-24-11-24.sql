--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

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
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: yourusername
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO yourusername;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: yourusername
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO yourusername;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: yourusername
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO yourusername;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: yourusername
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO yourusername;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.api_key OWNER TO yourusername;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO yourusername;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO yourusername;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.auth_identity OWNER TO yourusername;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.capture OWNER TO yourusername;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart OWNER TO yourusername;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_address OWNER TO yourusername;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_line_item OWNER TO yourusername;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_line_item_adjustment OWNER TO yourusername;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_line_item_tax_line OWNER TO yourusername;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO yourusername;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.cart_promotion OWNER TO yourusername;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_shipping_method OWNER TO yourusername;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO yourusername;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO yourusername;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.currency OWNER TO yourusername;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.customer OWNER TO yourusername;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.customer_address OWNER TO yourusername;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.customer_group OWNER TO yourusername;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.customer_group_customer OWNER TO yourusername;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.fulfillment OWNER TO yourusername;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.fulfillment_address OWNER TO yourusername;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.fulfillment_item OWNER TO yourusername;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.fulfillment_label OWNER TO yourusername;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment_provider OWNER TO yourusername;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.fulfillment_set OWNER TO yourusername;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.geo_zone OWNER TO yourusername;

--
-- Name: image; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.image OWNER TO yourusername;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.inventory_item OWNER TO yourusername;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.inventory_level OWNER TO yourusername;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.invite OWNER TO yourusername;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO yourusername;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO yourusername;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO yourusername;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO yourusername;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO yourusername;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO yourusername;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.notification OWNER TO yourusername;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.notification_provider OWNER TO yourusername;

--
-- Name: order; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public."order" OWNER TO yourusername;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_address OWNER TO yourusername;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_cart OWNER TO yourusername;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_change OWNER TO yourusername;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_change_action OWNER TO yourusername;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO yourusername;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_claim OWNER TO yourusername;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO yourusername;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_claim_item OWNER TO yourusername;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_claim_item_image OWNER TO yourusername;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO yourusername;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_exchange OWNER TO yourusername;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO yourusername;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_exchange_item OWNER TO yourusername;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO yourusername;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_item OWNER TO yourusername;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_line_item OWNER TO yourusername;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_line_item_adjustment OWNER TO yourusername;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_line_item_tax_line OWNER TO yourusername;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO yourusername;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.order_promotion OWNER TO yourusername;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_shipping OWNER TO yourusername;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_shipping_method OWNER TO yourusername;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_shipping_method_adjustment OWNER TO yourusername;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_shipping_method_tax_line OWNER TO yourusername;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_summary OWNER TO yourusername;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.order_transaction OWNER TO yourusername;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.payment OWNER TO yourusername;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.payment_collection OWNER TO yourusername;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO yourusername;

--
-- Name: payment_method_token; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.payment_method_token OWNER TO yourusername;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.payment_provider OWNER TO yourusername;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.payment_session OWNER TO yourusername;

--
-- Name: price; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.price OWNER TO yourusername;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.price_list OWNER TO yourusername;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.price_list_rule OWNER TO yourusername;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.price_preference OWNER TO yourusername;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.price_rule OWNER TO yourusername;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO yourusername;

--
-- Name: product; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product OWNER TO yourusername;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_category OWNER TO yourusername;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO yourusername;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_collection OWNER TO yourusername;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_images (
    product_id text NOT NULL,
    image_id text NOT NULL
);


ALTER TABLE public.product_images OWNER TO yourusername;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_option OWNER TO yourusername;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_option_value OWNER TO yourusername;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO yourusername;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO yourusername;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO yourusername;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO yourusername;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_variant OWNER TO yourusername;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.product_variant_inventory_item OWNER TO yourusername;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO yourusername;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO yourusername;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.promotion OWNER TO yourusername;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.promotion_application_method OWNER TO yourusername;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.promotion_campaign OWNER TO yourusername;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.promotion_campaign_budget OWNER TO yourusername;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO yourusername;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.promotion_rule OWNER TO yourusername;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO yourusername;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.provider_identity OWNER TO yourusername;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO yourusername;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.refund OWNER TO yourusername;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.refund_reason OWNER TO yourusername;

--
-- Name: region; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.region OWNER TO yourusername;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.region_country OWNER TO yourusername;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO yourusername;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.reservation_item OWNER TO yourusername;

--
-- Name: return; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.return OWNER TO yourusername;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: yourusername
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO yourusername;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yourusername
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO yourusername;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.return_item OWNER TO yourusername;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.return_reason OWNER TO yourusername;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.sales_channel OWNER TO yourusername;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO yourusername;

--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.service_zone OWNER TO yourusername;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.shipping_option OWNER TO yourusername;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp(0) with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO yourusername;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.shipping_option_rule OWNER TO yourusername;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.shipping_option_type OWNER TO yourusername;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.shipping_profile OWNER TO yourusername;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.stock_location OWNER TO yourusername;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.stock_location_address OWNER TO yourusername;

--
-- Name: store; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.store OWNER TO yourusername;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.store_currency OWNER TO yourusername;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: yourusername
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.tax_provider OWNER TO yourusername;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.tax_rate OWNER TO yourusername;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.tax_rate_rule OWNER TO yourusername;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.tax_region OWNER TO yourusername;

--
-- Name: user; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public."user" OWNER TO yourusername;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: yourusername
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


ALTER TABLE public.workflow_execution OWNER TO yourusername;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at) FROM stdin;
apk_01JBYPASJ7CX64V2V1ST9YSV90	pk_7491739a68884aceaec615471867efd7e33e4b4b07bd7ce58bd773af0c893853		pk_749***853	Webshop	publishable	\N		2024-11-05 17:35:33.959+00	\N	\N	2024-11-05 17:35:33.959+00
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at) FROM stdin;
authid_01JBYPDQQPSG5JH0M4HRE2GMB8	{"user_id": "user_01JBYPDPWY9M4V4V7QJ4VA9MWY"}	2024-11-05 17:37:10.39+00	2024-11-05 17:37:11.445+00
authid_01JC1M2DX70H1QK4D6G25HQM8E	{"user_id": "user_01JC1M2CNDN7FVRRTTPVZGFMV7"}	2024-11-06 20:53:46.023+00	2024-11-06 20:53:47.055+00
authid_01JC1MRK1QEFPYC37BQ3WM0PWY	{"user_id": "user_01JC1MRHV9WPHAPYNQAAY41VY2"}	2024-11-06 21:05:52.183+00	2024-11-06 21:05:53.411+00
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
cart_01JC1FV0QG0640QQVGP9X9RESW	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1FWXB9NGEX9TPDSAFZB4V4	sc_01JBYPA6S9ZG068M4VFJQNC33B	lopliok@gmail.com	eur	caaddr_01JC1FWYB7A2B05203KNEWP338	caaddr_01JC1FWYB7P4SXAMJ05MTB7WKS	\N	2024-11-06 19:39:48.849+00	2024-11-06 19:40:51.944+00	\N	\N
cart_01JC1NQ4J2644QFB9G7YBQE3YG	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	sc_01JBYPA6S9ZG068M4VFJQNC33B	hml-tester@hml.cz	eur	caaddr_01JC1NV753F5WKYSBJXKG8XEPK	caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N	2024-11-06 21:22:33.154+00	2024-11-06 21:27:13.857+00	\N	2024-11-06 21:27:12.303+00
cart_01JC65CWYFT35S2BANFZDX3AZY	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	cus_01JC1FWXB9NGEX9TPDSAFZB4V4	sc_01JBYPA6S9ZG068M4VFJQNC33B	lopliok@gmail.com	eur	caaddr_01JC68V1QMAWBGJJ2D25ENMAPF	caaddr_01JC68V1QK9GXPYBA6K6NW9VQ6	\N	2024-11-08 15:13:32.623+00	2024-11-08 16:13:42.004+00	\N	\N
cart_01JCE5Y3NW0MMN10CXFNX3B0VD	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	sc_01JBYPA6S9ZG068M4VFJQNC33B	\N	eur	\N	\N	\N	2024-11-11 17:56:52.029+00	2024-11-11 17:56:52.029+00	\N	\N
cart_01JD86WVD52ER5C8JS5N6M468V	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	sc_01JBYPA6S9ZG068M4VFJQNC33B	\N	eur	caaddr_01JD86WVD53DYYP91XPV3XFQA8	\N	\N	2024-11-21 20:33:54.598+00	2024-11-21 20:33:54.598+00	\N	\N
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01JC1FWYB7P4SXAMJ05MTB7WKS	\N	Lubomír Nedbal	Lubomír	Nedbal	Kostelní Radouň 85		Nová Včelnice	dk	Česká republika	378 42	722902317	\N	2024-11-06 19:40:51.943+00	2024-11-06 19:40:51.943+00	\N
caaddr_01JC1FWYB7A2B05203KNEWP338	\N	Lubomír Nedbal	Lubomír	Nedbal	Kostelní Radouň 85		Nová Včelnice	dk	Česká republika	378 42	722902317	\N	2024-11-06 19:40:51.944+00	2024-11-06 19:40:51.944+00	\N
caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00	\N
caaddr_01JC1NV753F5WKYSBJXKG8XEPK	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00	\N
caaddr_01JC68V1QK9GXPYBA6K6NW9VQ6	\N		Lubomír	Nedbal	Spálená 86/9		Praha 1	dk	South	110 00		\N	2024-11-08 16:13:42.004+00	2024-11-08 16:13:42.004+00	\N
caaddr_01JC68V1QMAWBGJJ2D25ENMAPF	\N		Lubomír	Nedbal	Spálená 86/9		Praha 1	dk	South	110 00		\N	2024-11-08 16:13:42.004+00	2024-11-08 16:13:42.004+00	\N
caaddr_01JD86WVD53DYYP91XPV3XFQA8	\N	\N	\N	\N	\N	\N	\N	pl	\N	\N	\N	\N	2024-11-21 20:33:54.598+00	2024-11-21 20:33:54.598+00	\N
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at) FROM stdin;
cali_01JC1NQNN7QHZWRC46VSPH20P9	cart_01JC1NQ4J2644QFB9G7YBQE3YG	M / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	2	variant_01JBYPBE916PJQVRTYSQH4HPHN	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:22:50.664+00	2024-11-06 21:25:35.155+00	\N
cali_01JC1FVCQPAQBM4V6F36ZKA3M1	cart_01JC1FV0QG0640QQVGP9X9RESW	L	Medusa Shorts	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	1	variant_01JBYPBE94X1RY6QPC9D54E12H	prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 19:40:01.142+00	2024-11-06 19:41:54.714+00	\N
cali_01JC1NSRFMWADF62NXS0VYWTR3	cart_01JC1NQ4J2644QFB9G7YBQE3YG	S / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	1	variant_01JBYPBE90Y0XBX14X6WRTQFRX	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-S-BLACK	\N	S / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:23:59.093+00	2024-11-06 21:25:35.155+00	\N
cali_01JC65D9DPXWF35N6KV34TFAD5	cart_01JC65CWYFT35S2BANFZDX3AZY	L	Medusa Shorts	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	3	variant_01JBYPBE94X1RY6QPC9D54E12H	prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-08 15:13:45.399+00	2024-11-08 16:30:14.031+00	\N
cali_01JCE5YGDVSY6CJFW218RVK74F	cart_01JCE5Y3NW0MMN10CXFNX3B0VD	Large (36 roses) / Pink / Luxury wrap with silk ribbon	Classic Rose Bouquet	http://localhost:9000/static/1731102278954-roses.jpg	1	variant_01JC6VSD9043GNQ97MGMJBT4HX	prod_01JC6VS1S74ACE8RN57D8P4VD1	Classic Rose Bouquet	A timeless bouquet of fresh roses, perfect for expressing love, gratitude, or admiration.	\N	\N	\N	classic-rose-bouquet	\N	\N	Large (36 roses) / Pink / Luxury wrap with silk ribbon	\N	t	t	f	\N	\N	60	{"value": "60", "precision": 20}	{}	2024-11-11 17:57:05.083+00	2024-11-11 17:57:08.408+00	\N
cali_01JDAW6DK2BMD79V6JGXZBJTK9	cart_01JD86WVD52ER5C8JS5N6M468V	Default option value	Tropical Paradise	http://localhost:9000/static/1731968175300-tropical-bouquet.webp	1	variant_01JD0NJ37JZF3H5WSH06QVM32B	prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	Tropical Paradise	Bring the tropics home with a vibrant arrangement of exotic orchids, bright lilies, and striking heliconia. A bold choice for celebrations.	\N	\N	Bouquets	tropical-paradise	\N	\N	Default option value	\N	t	t	f	\N	\N	70	{"value": "70", "precision": 20}	{}	2024-11-22 21:24:37.091+00	2024-11-22 22:19:57.521+00	\N
cali_01JDAZBR53V5GQ2QG6S5XCVRWS	cart_01JD86WVD52ER5C8JS5N6M468V	Medium	Ivory Grace	http://localhost:9000/static/1732304451401-white-roses.jpg	1	variant_01JDAP8DVKNC224PSQR8ZWNA2S	prod_01JDAP8DTNBE48Z55TMVER4V8J	Ivory Grace	A sophisticated bouquet featuring creamy white roses, soft peach carnations, and lush eucalyptus leaves, wrapped in elegant ivory-toned paper and tied with a satin ribbon. This refined arrangement embodies grace and subtle beauty, making it a perfect gift for anniversaries, weddings, or heartfelt celebrations. Its harmonious colors and modern design create a timeless and elegant appeal.	\N	\N	Bouquets	ivory-grace	\N	\N	Medium	\N	t	t	f	\N	\N	50	{"value": "50", "precision": 20}	{}	2024-11-22 22:19:57.476+00	2024-11-22 22:19:57.521+00	\N
cali_01JD86WVHWPGFN5H903AZAFZ8P	cart_01JD86WVD52ER5C8JS5N6M468V	Default option value	Tropical Paradise	http://localhost:9000/static/1731968175300-tropical-bouquet.webp	2	variant_01JD0NJ37JZF3H5WSH06QVM32B	prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	Tropical Paradise	Bring the tropics home with a vibrant arrangement of exotic orchids, bright lilies, and striking heliconia. A bold choice for celebrations.	\N	\N	Bouquets	tropical-paradise	\N	\N	Default option value	\N	t	t	f	\N	\N	70	{"value": "70", "precision": 20}	{}	2024-11-21 20:33:54.748+00	2024-11-22 21:16:23.309+00	2024-11-22 21:16:23.297+00
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
cart_01JC1NQ4J2644QFB9G7YBQE3YG	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	capaycol_01JC1NY6EWCN54EWHC7GHYV57X	2024-11-06 21:26:24+00	2024-11-06 21:26:24+00	\N
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
casm_01JC1FYRTFDTHRPPH6ZKK3GBKA	cart_01JC1FV0QG0640QQVGP9X9RESW	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 19:41:51.824+00	2024-11-06 19:41:55.943+00	\N
casm_01JC1NWJ64JXNHWWPZJ29BYWYT	cart_01JC1NQ4J2644QFB9G7YBQE3YG	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 21:25:30.948+00	2024-11-06 21:25:36.45+00	\N
casm_01JC68XFQ7E82N4F6NJFBJ84R9	cart_01JC65CWYFT35S2BANFZDX3AZY	Express Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQQ3Z5W0C1FCWNESSJX	{}	\N	2024-11-08 16:15:01.863+00	2024-11-08 16:30:10.959+00	2024-11-08 16:30:09.937+00
casm_01JC69S6A4S0NV7H5EJ7ZQN0GD	cart_01JC65CWYFT35S2BANFZDX3AZY	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-08 16:30:09.733+00	2024-11-08 16:30:14.97+00	\N
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
try	TL	TL	2	0	{"value": "0", "precision": 20}	Turkish Lira	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2024-11-05 17:35:01.022+00	2024-11-24 09:58:10.628+00	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.628+00	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2024-11-05 17:35:01.024+00	2024-11-24 09:58:10.629+00	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2024-11-05 17:35:01.023+00	2024-11-24 09:58:10.628+00	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.631+00	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2024-11-05 17:35:01.027+00	2024-11-24 09:58:10.631+00	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.63+00	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2024-11-05 17:35:01.025+00	2024-11-24 09:58:10.629+00	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2024-11-05 17:35:01.026+00	2024-11-24 09:58:10.63+00	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
cus_01JC1FWXB9NGEX9TPDSAFZB4V4	\N	\N	\N	lopliok@gmail.com	\N	f	\N	2024-11-06 19:40:50.922+00	2024-11-06 19:40:50.922+00	\N	\N
cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	\N	\N	\N	hml-tester@hml.cz	\N	f	\N	2024-11-06 21:24:45.632+00	2024-11-06 21:24:45.632+00	\N	\N
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment_provider (id, is_enabled) FROM stdin;
manual_manual	t
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01JBYPAJPFXBEPZA9QMJZEE55N	European Warehouse delivery	shipping	\N	2024-11-05 17:35:26.928+00	2024-11-05 17:35:26.928+00	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: yourusername
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
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: yourusername
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
img_01JD0JMM3CQEXHYFRSV1ZK1SRY	http://localhost:9000/static/1731965112308-sunflower.jpg	\N	2024-11-18 21:25:12.376614+00	2024-11-18 21:25:12.376614+00	\N
img_01JD0JTZCSZGG94D27MZT2E8AG	http://localhost:9000/static/1731965320543-rose-bouquet.jpg	\N	2024-11-18 21:28:40.589666+00	2024-11-18 21:28:40.589666+00	\N
img_01JD0KPTXS9AZAJH1T1V447BD0	http://localhost:9000/static/1731966233456-peonies.jpg	\N	2024-11-18 21:43:53.5039+00	2024-11-18 21:43:53.5039+00	\N
img_01JD0NJ36TYD4J02C51V2NEY38	http://localhost:9000/static/1731968175300-tropical-bouquet.webp	\N	2024-11-18 22:16:15.31667+00	2024-11-18 22:16:15.31667+00	\N
img_01JDAN74YV1JTPJGJDNM75RQCH	http://localhost:9000/static/1732303360966-sunset-roses.jpg	\N	2024-11-22 19:22:40.977117+00	2024-11-22 19:22:40.977117+00	\N
img_01JDANWN37GHMXAN21ZEK2DQCS	http://localhost:9000/static/1732304065619-white-peonies.jpg	\N	2024-11-22 19:34:25.635948+00	2024-11-22 19:34:25.635948+00	\N
img_01JDAP8DTRSQKKMVR5NH0SME81	http://localhost:9000/static/1732304451401-white-roses.jpg	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01JBYPBK4TFGBRW15DF20VZY6B	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01JBYPBK4TF0GS9ZFSHHPWK09N	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01JBYPBK4TW63S8CF5JAG3P135	2024-11-05 17:36:00.156+00	2024-11-05 17:36:00.156+00	\N	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
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
iitem_01JBYPBK4T43KYXWP8G8P59Q5A	2024-11-05 17:36:00.156+00	2024-11-14 21:19:43.975+00	2024-11-14 21:19:43.974+00	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	2024-11-05 17:36:00.156+00	2024-11-14 21:19:43.982+00	2024-11-14 21:19:43.974+00	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01JBYPBK4TB145EVQ7DXTTV2MP	2024-11-05 17:36:00.156+00	2024-11-14 21:19:43.988+00	2024-11-14 21:19:43.974+00	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	2024-11-05 17:36:00.156+00	2024-11-14 21:19:43.992+00	2024-11-14 21:19:43.974+00	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01JBYPBQG1KAGW6VCC9C8TBKM4	2024-11-05 17:36:04.612+00	2024-11-05 17:36:04.612+00	\N	iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
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
ilev_01JBYPBQG2X6CK6R8540EX0KZG	2024-11-05 17:36:04.613+00	2024-11-14 21:19:43.982+00	2024-11-14 21:19:43.974+00	iitem_01JBYPBK4T43KYXWP8G8P59Q5A	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG266FVTHMEMK33H0FS	2024-11-05 17:36:04.613+00	2024-11-14 21:19:43.988+00	2024-11-14 21:19:43.974+00	iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2SJTM9WCK2RAEVKV5	2024-11-05 17:36:04.613+00	2024-11-14 21:19:43.992+00	2024-11-14 21:19:43.974+00	iitem_01JBYPBK4TB145EVQ7DXTTV2MP	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01JBYPBQG2P48B0P23QRA3JX6P	2024-11-05 17:36:04.613+00	2024-11-14 21:19:43.996+00	2024-11-14 21:19:43.974+00	iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: yourusername
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
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	manual_manual	locfp_01JBYPAHFZYEHXH6WRZGBP5CZ0	2024-11-05 17:35:25+00	2024-11-05 17:35:25+00	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	fuset_01JBYPAJPFXBEPZA9QMJZEE55N	locfs_01JBYPAKPBNJJM0DKCBGN3GY41	2024-11-05 17:35:28+00	2024-11-05 17:35:28+00	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: yourusername
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
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
noti_01JBYRGCZBXF9NRKF9EST11JYH		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1730830414182-1730830414155-product-exports.csv", "filename": "1730830414155-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-05 18:13:34.83+00	2024-11-05 18:13:35.674+00	\N	success
noti_01JBYRH6WS9BC5QC33MD84T100		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1730830441006-1730830441006-product-exports.csv", "filename": "1730830441006-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-05 18:14:01.369+00	2024-11-05 18:14:02.159+00	\N	success
noti_01JCE3T0DH2KB72RCBZWYE3PKC		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1731345579739-1731345579737-product-exports.csv", "filename": "1731345579737-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:19:40.466+00	2024-11-11 17:19:41.158+00	\N	success
noti_01JCE55W2MZW9T6MY9Q3HFRZNX		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file custom_lily_romance_product_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:43:37.813+00	2024-11-11 17:43:38.824+00	\N	success
noti_01JCE57QF2EBE6GC4JF3YS8GTY		feed	admin-ui	{"title": "Product import", "description": "Failed to import products from file custom_lily_romance_product_import.csv"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-11 17:44:38.626+00	2024-11-11 17:44:39.344+00	\N	success
noti_01JD0NNAJE0CT5QC7REA2WJ2KT		feed	admin-ui	{"file": {"url": "http://localhost:9000/static/private-1731968281160-1731968281160-product-exports.csv", "filename": "1731968281160-product-exports.csv", "mimeType": "text/csv"}, "title": "Product export", "description": "Product export completed successfully!"}	\N	\N	\N	\N	\N	\N	\N	local	2024-11-18 22:18:01.167+00	2024-11-18 22:18:01.171+00	\N	success
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2024-11-05 17:35:07.161+00	2024-11-05 17:35:07.161+00	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	1	cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ	1	sc_01JBYPA6S9ZG068M4VFJQNC33B	canceled	f	hml-tester@hml.cz	eur	caaddr_01JC1NV753F5WKYSBJXKG8XEPK	caaddr_01JC1NV753PR1XC49BZWQE9ACA	f	\N	2024-11-06 21:27:08.105+00	2024-11-08 22:15:04.879+00	\N	2024-11-08 22:15:04.659+00
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at) FROM stdin;
caaddr_01JC1NV753F5WKYSBJXKG8XEPK	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00
caaddr_01JC1NV753PR1XC49BZWQE9ACA	\N		hml	tester	Revolucni 10		Praha	dk	1	10610	504010204	\N	2024-11-06 21:24:46.883+00	2024-11-06 21:24:46.883+00
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	cart_01JC1NQ4J2644QFB9G7YBQE3YG	ordercart_01JC1NZNB97XGC132PDAX3S61X	2024-11-06 21:27:12+00	2024-11-06 21:27:12+00	\N
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01JC1NZH29KK3B0D1TZAABWJCH	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordli_01JC1NZH288S4WS3MJ4RG4FP3X	2	{"value": "2", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.106+00	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01JC1NZH299WSNS8KAC57267V5	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordli_01JC1NZH28MV8MKF2EYK723HMN	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.106+00	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price) FROM stdin;
ordli_01JC1NZH288S4WS3MJ4RG4FP3X	\N	M / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	variant_01JBYPBE916PJQVRTYSQH4HPHN	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:27:08.105+00	2024-11-06 21:27:08.105+00	\N	f
ordli_01JC1NZH28MV8MKF2EYK723HMN	\N	S / Black	Medusa T-Shirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	variant_01JBYPBE90Y0XBX14X6WRTQFRX	prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-S-BLACK	\N	S / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2024-11-06 21:27:08.105+00	2024-11-06 21:27:08.106+00	\N	f
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JC1NZH27XD1DJ2Q134XE9PXC	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	ordpay_01JC1NZNXE4FG9E3KCSTXPQ16D	2024-11-06 21:27:13+00	2024-11-06 21:27:13+00	\N
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordspmv_01JC1NZH27JT2X40VVKXAE01GG	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	ordsm_01JC1NZH27D7CFCR21D8B66RHT	2024-11-06 21:27:08.107+00	2024-11-06 21:27:08.107+00	\N	\N	\N	\N
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
ordsm_01JC1NZH27D7CFCR21D8B66RHT	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JBYPANQPHC24PMZKPRMX0FRG	{}	\N	2024-11-06 21:27:08.107+00	2024-11-06 21:27:08.107+00	\N	f
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
ordsum_01JC1NZH27SWJRHX3PZFVCQWKB	order_01JC1NZH27XD1DJ2Q134XE9PXC	1	{"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}	2024-11-06 21:27:08.106+00	2024-11-06 21:27:08.107+00	\N
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, cart_id, order_id, customer_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
pay_01JC1NZD0TAH7A0SSMYA0MHMCM	40	{"value": "40", "precision": 20}	eur	pp_system_default	\N	\N	\N	{}	2024-11-06 21:27:03.962+00	2024-11-08 22:15:05.781+00	\N	\N	2024-11-08 22:15:03.943+00	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	payses_01JC1NY9N9KJ1DQ1233AFDZP6B	\N
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, region_id, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	eur	40	{"value": "40", "precision": 20}	40	{"value": "40", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	2024-11-06 21:26:23.587+00	2024-11-06 21:27:05.184+00	\N	\N	authorized	\N
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_method_token; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment_method_token (id, provider_id, data, name, type_detail, description_detail, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment_provider (id, is_enabled) FROM stdin;
pp_system_default	t
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
payses_01JC1NY9N9KJ1DQ1233AFDZP6B	eur	40	{"value": "40", "precision": 20}	pp_system_default	{}	{}	authorized	2024-11-06 21:27:03.771+00	pay_col_01JC1NY5K3RC1BSFF1GVHVFE27	\N	2024-11-06 21:26:27.753+00	2024-11-06 21:27:03.963+00	\N
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: yourusername
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
price_01JBYPBN442VF7K46G69XH9VWV	\N	pset_01JBYPBN45BKME4FTW7J471GJH	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.029+00	2024-11-14 21:19:44.02+00	\N	10	\N	\N
price_01JBYPBN443X2NX4CEK93F7F6R	\N	pset_01JBYPBN45BKME4FTW7J471GJH	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.031+00	2024-11-14 21:19:44.02+00	\N	15	\N	\N
price_01JBYPBN454K1V6SGSWX85JCAZ	\N	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.036+00	2024-11-14 21:19:44.02+00	\N	10	\N	\N
price_01JBYPBN45R9Z3RT48684PCE81	\N	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-14 21:19:44.038+00	2024-11-14 21:19:44.02+00	\N	15	\N	\N
price_01JBYPBN45RWVKYC2AQRKS1KWK	\N	pset_01JBYPBN45JZZH804E5GQ9GMFW	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-14 21:19:44.042+00	2024-11-14 21:19:44.02+00	\N	10	\N	\N
price_01JBYPBN4567SE6H8C55ZH1Z3T	\N	pset_01JBYPBN45JZZH804E5GQ9GMFW	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-14 21:19:44.044+00	2024-11-14 21:19:44.02+00	\N	15	\N	\N
price_01JBYPBN4639DYYY74R65P0VGG	\N	pset_01JBYPBN4655WQ418G1D71R7TT	eur	{"value": "10", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-14 21:19:44.048+00	2024-11-14 21:19:44.02+00	\N	10	\N	\N
price_01JBYPBN46CAWRS634GZGR12BH	\N	pset_01JBYPBN4655WQ418G1D71R7TT	usd	{"value": "15", "precision": 20}	0	2024-11-05 17:36:02.188+00	2024-11-14 21:19:44.05+00	2024-11-14 21:19:44.02+00	\N	15	\N	\N
price_01JD0JMM853FGY6ZGCMVBGG7GG	\N	pset_01JD0JMM86VY1VBW25NWA6Z8FN	eur	{"value": "25", "precision": 20}	0	2024-11-18 21:25:12.587+00	2024-11-18 21:25:12.587+00	\N	\N	25	\N	\N
price_01JD0JMM865HJ1S1S8BXSBRV1W	\N	pset_01JD0JMM87GHSS7805REWBFF3D	eur	{"value": "40", "precision": 20}	0	2024-11-18 21:25:12.588+00	2024-11-18 21:25:12.588+00	\N	\N	40	\N	\N
price_01JD0JMM87TXP99KRXEC766XBM	\N	pset_01JD0JMM88PMD942KV5FJGYP0C	eur	{"value": "60", "precision": 20}	0	2024-11-18 21:25:12.588+00	2024-11-18 21:25:12.588+00	\N	\N	60	\N	\N
price_01JD0KPV4B4DN2RD24Z60HVSP2	\N	pset_01JD0KPV4B452532XT7KE2RWGD	eur	{"value": "35", "precision": 20}	0	2024-11-18 21:43:53.743+00	2024-11-18 21:43:53.743+00	\N	\N	35	\N	\N
price_01JD0KPV4CCKEQQQW66R2C6MTJ	\N	pset_01JD0KPV4CB55NA89T3N8F5PBP	eur	{"value": "60", "precision": 20}	0	2024-11-18 21:43:53.743+00	2024-11-18 21:43:53.743+00	\N	\N	60	\N	\N
price_01JD0KPV4D44QAP59KD5BMZX29	\N	pset_01JD0KPV4DD32K9J21SHNEJGJF	eur	{"value": "90", "precision": 20}	0	2024-11-18 21:43:53.743+00	2024-11-18 21:43:53.743+00	\N	\N	90	\N	\N
price_01JD0NJ382AA4ZKY81WJ6T7DBH	\N	pset_01JD0NJ382VCAN1949G2Y62R9Z	eur	{"value": "70", "precision": 20}	0	2024-11-18 22:16:15.362+00	2024-11-18 22:16:15.362+00	\N	\N	70	\N	\N
price_01JDANWN4DEGVC0Y7Y7AE54NQ2	\N	pset_01JDANWN4D5FYZBGVM87XEBV6Z	eur	{"value": "35", "precision": 20}	0	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N	\N	35	\N	\N
price_01JDANWN4ETT3Y1PRBBXKRA4E7	\N	pset_01JDANWN4E2PX5XKZX6T16XYYZ	eur	{"value": "60", "precision": 20}	0	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N	\N	60	\N	\N
price_01JDANWN4EW5G1XHJZ5A5EPSY7	\N	pset_01JDANWN4EXDDT303CVMG69RQR	eur	{"value": "80", "precision": 20}	0	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N	\N	80	\N	\N
price_01JDAP8DWDERSRR28N55H6PXAP	\N	pset_01JDAP8DWDS0C5G7ZSB82NVRKG	eur	{"value": "30", "precision": 20}	0	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N	\N	30	\N	\N
price_01JDAP8DWDGWVS1GE0P8HKEEC3	\N	pset_01JDAP8DWDSS7XYBAA1QJEWDEZ	eur	{"value": "50", "precision": 20}	0	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N	\N	50	\N	\N
price_01JDAP8DWD6FM1CYRGG5SBC4KF	\N	pset_01JDAP8DWEM1JE65W7PESRGATM	eur	{"value": "75", "precision": 20}	0	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N	\N	75	\N	\N
price_01JDAPNJJGG66QTQXX76H2SN0W	\N	pset_01JDAPNJJG111HS794K8R4H9TR	eur	{"value": "40", "precision": 20}	0	2024-11-22 19:48:02.257+00	2024-11-22 19:48:02.257+00	\N	\N	40	\N	\N
price_01JDAPPVAV4SHVKJADM87CV9ZM	\N	pset_01JDAPPVAVWW5AKPJB0MRSHGC2	eur	{"value": "45", "precision": 20}	0	2024-11-22 19:48:43.995+00	2024-11-22 19:48:43.995+00	\N	\N	45	\N	\N
price_01JDAPQWFMS9FAWBW5KSNFRPS1	\N	pset_01JDAPQWFMNF1W5P6GY8F4GEY8	eur	{"value": "45", "precision": 20}	0	2024-11-22 19:49:17.941+00	2024-11-22 19:49:17.941+00	\N	\N	45	\N	\N
price_01JDAPRVZP38ZY8ZQCZV5F69VT	\N	pset_01JDAPRVZP3FZC0PVDEF56309P	eur	{"value": "60", "precision": 20}	0	2024-11-22 19:49:50.198+00	2024-11-22 19:49:50.198+00	\N	\N	60	\N	\N
price_01JDAPSJMY327KEFPY3FKNXDJ5	\N	pset_01JDAPSJMYA9XX41HBGBSQPQD1	eur	{"value": "65", "precision": 20}	0	2024-11-22 19:50:13.406+00	2024-11-22 19:50:13.406+00	\N	\N	65	\N	\N
price_01JDAPTCV2781T52WFFG7M09TC	\N	pset_01JDAPTCV2WMYF7GR6Q8EWC6K2	eur	{"value": "65", "precision": 20}	0	2024-11-22 19:50:40.227+00	2024-11-22 19:50:40.227+00	\N	\N	65	\N	\N
price_01JDAPVNWVXEZGY6RA4GWG4BR6	\N	pset_01JDAPVNWVW7NV96V816R7A78E	eur	{"value": "80", "precision": 20}	0	2024-11-22 19:51:22.268+00	2024-11-22 19:51:22.268+00	\N	\N	80	\N	\N
price_01JDAPWAGTC5RQNH0M3KY9ZV57	\N	pset_01JDAPWAGTBJR5E0EV07WJAEDN	eur	{"value": "85", "precision": 20}	0	2024-11-22 19:51:43.386+00	2024-11-22 19:51:43.386+00	\N	\N	85	\N	\N
price_01JDAPWXTP2TQNJBTD66P0Q3J7	\N	pset_01JDAPWXTP938JT0J8SDAD44N0	eur	{"value": "85", "precision": 20}	0	2024-11-22 19:52:03.158+00	2024-11-22 19:52:03.158+00	\N	\N	85	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01JBYPA99JPE3JNQV0RWT4WY52	currency_code	eur	f	2024-11-05 17:35:17.299+00	2024-11-05 17:35:17.299+00	\N
prpref_01JBYPACNJWCMNDY7PNYPESN43	currency_code	usd	f	2024-11-05 17:35:20.754+00	2024-11-05 17:35:20.754+00	\N
prpref_01JBYPAF3AAB1RN71J9VM4MTJ6	region_id	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	f	2024-11-05 17:35:23.242+00	2024-11-05 17:35:23.242+00	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute) FROM stdin;
prule_01JBYPAPZ164388Z7Z454Q4WEZ	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	0	price_01JBYPAPZ1AYXMQ4ZV57DTHBKF	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	region_id
prule_01JBYPAPZ328XWVFRS3B1ADNAT	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	0	price_01JBYPAPZ3B61PCW1RQQ92H8YK	2024-11-05 17:35:31.301+00	2024-11-05 17:35:31.301+00	\N	region_id
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01JBYPAPZ2HAEWHH400PK8M6GF	2024-11-05 17:35:31.3+00	2024-11-05 17:35:31.3+00	\N
pset_01JBYPAPZ336WJ0KEYPADK7KMW	2024-11-05 17:35:31.3+00	2024-11-05 17:35:31.3+00	\N
pset_01JBYPBN43WFEPMS6Y68FV6BN5	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN43X9Y2563SPBB2G3JQ	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN4443WRQDKTZEE411C4	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
pset_01JBYPBN44ZY6349NTPX34KKY2	2024-11-05 17:36:02.186+00	2024-11-05 17:36:02.186+00	\N
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
pset_01JBYPBN45BKME4FTW7J471GJH	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.021+00	2024-11-14 21:19:44.02+00
pset_01JBYPBN45Q2XGJ7C6180MYGJ6	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.031+00	2024-11-14 21:19:44.02+00
pset_01JBYPBN45JZZH804E5GQ9GMFW	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.038+00	2024-11-14 21:19:44.02+00
pset_01JBYPBN4655WQ418G1D71R7TT	2024-11-05 17:36:02.187+00	2024-11-14 21:19:44.044+00	2024-11-14 21:19:44.02+00
pset_01JD0JMM86VY1VBW25NWA6Z8FN	2024-11-18 21:25:12.586+00	2024-11-18 21:25:12.586+00	\N
pset_01JD0JMM87GHSS7805REWBFF3D	2024-11-18 21:25:12.586+00	2024-11-18 21:25:12.586+00	\N
pset_01JD0JMM88PMD942KV5FJGYP0C	2024-11-18 21:25:12.586+00	2024-11-18 21:25:12.586+00	\N
pset_01JD0KPV4B452532XT7KE2RWGD	2024-11-18 21:43:53.742+00	2024-11-18 21:43:53.742+00	\N
pset_01JD0KPV4CB55NA89T3N8F5PBP	2024-11-18 21:43:53.742+00	2024-11-18 21:43:53.742+00	\N
pset_01JD0KPV4DD32K9J21SHNEJGJF	2024-11-18 21:43:53.743+00	2024-11-18 21:43:53.743+00	\N
pset_01JD0NJ382VCAN1949G2Y62R9Z	2024-11-18 22:16:15.362+00	2024-11-18 22:16:15.362+00	\N
pset_01JDANWN4D5FYZBGVM87XEBV6Z	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N
pset_01JDANWN4E2PX5XKZX6T16XYYZ	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N
pset_01JDANWN4EXDDT303CVMG69RQR	2024-11-22 19:34:25.678+00	2024-11-22 19:34:25.678+00	\N
pset_01JDAP8DWDS0C5G7ZSB82NVRKG	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N
pset_01JDAP8DWDSS7XYBAA1QJEWDEZ	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N
pset_01JDAP8DWEM1JE65W7PESRGATM	2024-11-22 19:40:51.47+00	2024-11-22 19:40:51.47+00	\N
pset_01JDAN750Q7NCG60X8SVJSYZJ5	2024-11-22 19:22:41.048+00	2024-11-22 19:44:33.132+00	2024-11-22 19:44:33.131+00
pset_01JDAPNJJG111HS794K8R4H9TR	2024-11-22 19:48:02.257+00	2024-11-22 19:48:02.257+00	\N
pset_01JDAPPVAVWW5AKPJB0MRSHGC2	2024-11-22 19:48:43.995+00	2024-11-22 19:48:43.995+00	\N
pset_01JDAPQWFMNF1W5P6GY8F4GEY8	2024-11-22 19:49:17.941+00	2024-11-22 19:49:17.941+00	\N
pset_01JDAPRVZP3FZC0PVDEF56309P	2024-11-22 19:49:50.198+00	2024-11-22 19:49:50.198+00	\N
pset_01JDAPSJMYA9XX41HBGBSQPQD1	2024-11-22 19:50:13.406+00	2024-11-22 19:50:13.406+00	\N
pset_01JDAPTCV2WMYF7GR6Q8EWC6K2	2024-11-22 19:50:40.226+00	2024-11-22 19:50:40.226+00	\N
pset_01JDAPVNWVW7NV96V816R7A78E	2024-11-22 19:51:22.268+00	2024-11-22 19:51:22.268+00	\N
pset_01JDAPWAGTBJR5E0EV07WJAEDN	2024-11-22 19:51:43.386+00	2024-11-22 19:51:43.386+00	\N
pset_01JDAPWXTP938JT0J8SDAD44N0	2024-11-22 19:52:03.158+00	2024-11-22 19:52:03.158+00	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01JBYPAX9KTG1VRTK059RV2VWZ	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:48.911+00	2024-11-08 22:17:48.911+00	\N
prod_01JBYPAX9MM5R7BNNF72RKRWEY	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:13.745+00	2024-11-08 22:18:13.744+00	\N
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.01+00	2024-11-14 21:19:44.009+00	\N
prod_01JBYPAX9MZD59BMNW71AXBF23	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	draft	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N	\N
prod_01JD0JMM2QYTH0T2H8B8FD6D6M	Sunshine Charm	sunshine-charm	\N	Brighten someone’s day with a cheerful mix of sunflowers, daisies, and yellow roses. A perfect pick-me-up for any occasion.	f	published	http://localhost:9000/static/1731965112308-sunflower.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-18 21:25:12.376614+00	2024-11-21 20:23:04.62+00	\N	\N
prod_01JD0KPTXF4EH9H01K5WQNKBG6	Pastel Bliss	pastel-bliss	\N	Soft and sweet, this bouquet features pastel pink peonies for a dreamy, elegant look.	f	published	http://localhost:9000/static/1731966233456-peonies.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-18 21:43:53.5039+00	2024-11-21 20:23:04.62+00	\N	\N
prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	Tropical Paradise	tropical-paradise	\N	Bring the tropics home with a vibrant arrangement of exotic orchids, bright lilies, and striking heliconia. A bold choice for celebrations.	f	published	http://localhost:9000/static/1731968175300-tropical-bouquet.webp	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-18 22:16:15.31667+00	2024-11-21 20:23:04.62+00	\N	\N
prod_01JC6VS1S74ACE8RN57D8P4VD1	Crimson Dream	classic-rose-bouquet	\N	A luxurious arrangement of deep red roses complemented by vibrant greenery. Perfect for romantic occasions and celebrations.	f	published		\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-08 21:44:39.080448+00	2024-11-21 20:23:04.62+00	\N	\N
prod_01JDAN74YNGD7F94RCYVMYT9AF	Sunset Whispers	sunset-whispers	\N	A delicate arrangement featuring peach-toned roses complemented by soft pink carnations, tiny white blossoms, and lush greenery. This bouquet exudes elegance and warmth, perfect for expressing admiration, celebrating milestones, or brightening any room. Its harmonious blend of colors makes it ideal for romantic occasions or as a thoughtful gift.	f	published	http://localhost:9000/static/1732303360966-sunset-roses.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-22 19:22:40.977117+00	2024-11-22 19:22:40.977117+00	\N	\N
prod_01JDANWN36T6E3320AVST9Y9FW	Pure Elegance	pure-elegance	\N	A minimalist bouquet of delicate white peonies wrapped in rustic brown kraft paper. The soft, full blooms exude purity and grace, making it a perfect gift for weddings, anniversaries, or as a thoughtful gesture of love and appreciation. The understated wrapping enhances its natural beauty, creating a timeless and elegant look.	f	published	http://localhost:9000/static/1732304065619-white-peonies.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-22 19:34:25.635948+00	2024-11-22 19:34:25.635948+00	\N	\N
prod_01JDAP8DTNBE48Z55TMVER4V8J	Ivory Grace	ivory-grace	\N	A sophisticated bouquet featuring creamy white roses, soft peach carnations, and lush eucalyptus leaves, wrapped in elegant ivory-toned paper and tied with a satin ribbon. This refined arrangement embodies grace and subtle beauty, making it a perfect gift for anniversaries, weddings, or heartfelt celebrations. Its harmonious colors and modern design create a timeless and elegant appeal.	f	published	http://localhost:9000/static/1732304451401-white-roses.jpg	\N	\N	\N	\N	\N	\N	\N	\N	pcol_01JD868A8H7KGPWCHEAF48598X	\N	t	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01JBYPAV9J63ACGHK3EZF986YP	Roses		roses	pcat_01JBYPAV9J63ACGHK3EZF986YP	t	f	0	\N	2024-11-05 17:35:36.284+00	2024-11-21 20:23:59.286+00	\N	\N
pcat_01JBYPAVFYDGSV952FVKMRE42H	Sweatshirts		sweatshirts	pcat_01JBYPAVFYDGSV952FVKMRE42H	t	f	1	\N	2024-11-05 17:35:36.284+00	2024-11-21 20:24:12.3+00	2024-11-21 20:24:12.3+00	\N
pcat_01JBYPAVNGEVRA2JPAGANW1HB6	Pants		pants	pcat_01JBYPAVNGEVRA2JPAGANW1HB6	t	f	1	\N	2024-11-05 17:35:36.285+00	2024-11-21 20:24:17.05+00	2024-11-21 20:24:17.05+00	\N
pcat_01JBYPAVTWVYWGJWEXT8QGBPXY	Merch		merch	pcat_01JBYPAVTWVYWGJWEXT8QGBPXY	f	f	1	\N	2024-11-05 17:35:36.285+00	2024-11-21 20:24:38.438+00	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01JBYPAX9KTG1VRTK059RV2VWZ	pcat_01JBYPAV9J63ACGHK3EZF986YP
prod_01JBYPAX9MZD59BMNW71AXBF23	pcat_01JBYPAVFYDGSV952FVKMRE42H
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	pcat_01JBYPAVNGEVRA2JPAGANW1HB6
prod_01JBYPAX9MM5R7BNNF72RKRWEY	pcat_01JBYPAVTWVYWGJWEXT8QGBPXY
prod_01JC6VS1S74ACE8RN57D8P4VD1	pcat_01JBYPAV9J63ACGHK3EZF986YP
prod_01JDAN74YNGD7F94RCYVMYT9AF	pcat_01JBYPAV9J63ACGHK3EZF986YP
prod_01JDAP8DTNBE48Z55TMVER4V8J	pcat_01JBYPAV9J63ACGHK3EZF986YP
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01JD868A8H7KGPWCHEAF48598X	Bouquets	bouquets	\N	2024-11-21 20:22:41.680232+00	2024-11-21 20:22:41.680232+00	\N
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: yourusername
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
prod_01JD0JMM2QYTH0T2H8B8FD6D6M	img_01JD0JMM3CQEXHYFRSV1ZK1SRY
prod_01JC6VS1S74ACE8RN57D8P4VD1	img_01JD0JTZCSZGG94D27MZT2E8AG
prod_01JD0KPTXF4EH9H01K5WQNKBG6	img_01JD0KPTXS9AZAJH1T1V447BD0
prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	img_01JD0NJ36TYD4J02C51V2NEY38
prod_01JDAN74YNGD7F94RCYVMYT9AF	img_01JDAN74YV1JTPJGJDNM75RQCH
prod_01JDANWN36T6E3320AVST9Y9FW	img_01JDANWN37GHMXAN21ZEK2DQCS
prod_01JDAP8DTNBE48Z55TMVER4V8J	img_01JDAP8DTRSQKKMVR5NH0SME81
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01JBYPB4WTHM535A7FEV9TNXKC	Size	prod_01JBYPAX9MZD59BMNW71AXBF23	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
opt_01JBYPB4WTQ648S23QZCGH6M03	Size	prod_01JBYPAX9KTG1VRTK059RV2VWZ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:49.832+00	2024-11-08 22:17:48.911+00
opt_01JBYPB4WT12SATPCJVHP6BTXR	Color	prod_01JBYPAX9KTG1VRTK059RV2VWZ	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:17:50.853+00	2024-11-08 22:17:48.911+00
opt_01JBYPB4WVAJ1C086RCCG4XAYQ	Size	prod_01JBYPAX9MM5R7BNNF72RKRWEY	\N	2024-11-05 17:35:36.703125+00	2024-11-08 22:18:14.308+00	2024-11-08 22:18:13.744+00
opt_01JBYPB4WVJMG3R7WSWVAAXHZR	Size	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.016+00	2024-11-14 21:19:44.009+00
opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	Size	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-14 21:21:29.308+00	2024-11-14 21:21:29.308+00
opt_01JD0JMM42WM0NZ77CG9BZNCZC	Size	prod_01JD0JMM2QYTH0T2H8B8FD6D6M	\N	2024-11-18 21:25:12.376614+00	2024-11-18 21:25:12.376614+00	\N
opt_01JD0NJ370NV7VB3GEW48D4F6T	Default option	prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	\N	2024-11-18 22:16:15.31667+00	2024-11-18 22:16:15.31667+00	\N
opt_01JD0KPTYPBG254FXMZPN9N506	Size	prod_01JD0KPTXF4EH9H01K5WQNKBG6	\N	2024-11-18 21:43:53.5039+00	2024-11-18 21:43:53.5039+00	\N
opt_01JC6VS3NF1PS4NTVVFH4ATR3J	Color	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-22 19:09:04.828+00	2024-11-22 19:09:04.827+00
opt_01JDANDPA6A2H7355R8XG738C1	Size	prod_01JDAN74YNGD7F94RCYVMYT9AF	\N	2024-11-22 19:26:15.366+00	2024-11-22 19:26:15.366+00	\N
opt_01JDAN74Z6SKA7YRJP6WJ20A05	Default option	prod_01JDAN74YNGD7F94RCYVMYT9AF	\N	2024-11-22 19:22:40.977117+00	2024-11-22 19:27:00.419+00	2024-11-22 19:27:00.419+00
opt_01JDANG4WDYM1G7RVF4VTJTMR2	Wrapping style	prod_01JDAN74YNGD7F94RCYVMYT9AF	\N	2024-11-22 19:27:35.821+00	2024-11-22 19:27:35.821+00	\N
opt_01JDAP8DTXBEY03RKA48X7DE57	Size	prod_01JDAP8DTNBE48Z55TMVER4V8J	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N
opt_01JDANWN3B2W8ES48B2GTSA6ZS	Size	prod_01JDANWN36T6E3320AVST9Y9FW	\N	2024-11-22 19:34:25.635948+00	2024-11-22 19:34:25.635948+00	\N
opt_01JDAVWNDSH1M03TGZX76G9GFM	Size	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-22 21:19:17.433+00	2024-11-22 21:19:17.433+00	\N
opt_01JC6VS3NGF8EQTMCGY8SYXKVT	Wrapping Style	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-08 21:44:39.080448+00	2024-11-22 21:23:10.532+00	2024-11-22 21:23:10.532+00
opt_01JDAW5QYBVVE3Y0F08KKNY4V8	Wrapping style	prod_01JC6VS1S74ACE8RN57D8P4VD1	\N	2024-11-22 21:24:14.923+00	2024-11-22 21:24:14.923+00	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01JBYPB66BSV8KKNMJE5RQGJMF	S	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66C2J1MBV7XAW61JJT1	M	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66CM34CM0TB0GQJGNSH	L	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
optval_01JBYPB66CMXY4TR6M25G2Y3SP	XL	opt_01JBYPB4WTHM535A7FEV9TNXKC	\N	2024-11-05 17:35:36.703125+00	2024-11-05 17:35:36.703125+00	\N
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
optval_01JBYPB6CS8X5RZ5P8H21SY2QD	S	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.022+00	2024-11-14 21:19:44.009+00
optval_01JBYPB6CSNMBJ8R9Z2GWK8388	M	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.022+00	2024-11-14 21:19:44.009+00
optval_01JBYPB6CS0DAKGQ6W717NQ1JK	L	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.022+00	2024-11-14 21:19:44.009+00
optval_01JBYPB6CSKD4Y40V7MKP63DFG	XL	opt_01JBYPB4WVJMG3R7WSWVAAXHZR	\N	2024-11-05 17:35:36.703125+00	2024-11-14 21:19:44.022+00	2024-11-14 21:19:44.009+00
optval_01JC6VS50TC1QBR8627E1XQJRP	Small (12 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-14 21:21:29.311+00	2024-11-14 21:21:29.308+00
optval_01JC6VS50TQ4NGWAV72QCFS8NH	Medium (24 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-14 21:21:29.311+00	2024-11-14 21:21:29.308+00
optval_01JC6VS50VW0T89WR5DVDNJ675	Large (36 roses)	opt_01JC6VS3NF1PZYSPZPKHG8ET1Q	\N	2024-11-08 21:44:39.080448+00	2024-11-14 21:21:29.311+00	2024-11-14 21:21:29.308+00
optval_01JD0JMM45DNC8E0YTV5S76A09	Small	opt_01JD0JMM42WM0NZ77CG9BZNCZC	\N	2024-11-18 21:25:12.376614+00	2024-11-18 21:25:12.376614+00	\N
optval_01JD0JMM460WYRT6BKR23FERRR	Medium	opt_01JD0JMM42WM0NZ77CG9BZNCZC	\N	2024-11-18 21:25:12.376614+00	2024-11-18 21:25:12.376614+00	\N
optval_01JD0JMM461KXPWVDJQJ5KM82N	Large	opt_01JD0JMM42WM0NZ77CG9BZNCZC	\N	2024-11-18 21:25:12.376614+00	2024-11-18 21:25:12.376614+00	\N
optval_01JD0NJ372870342EQ9EZNR9C5	Default option value	opt_01JD0NJ370NV7VB3GEW48D4F6T	\N	2024-11-18 22:16:15.31667+00	2024-11-18 22:16:15.31667+00	\N
optval_01JDAKMHBGBPBAWVJJV97789SG	Small	opt_01JD0KPTYPBG254FXMZPN9N506	\N	2024-11-22 18:55:02.497289+00	2024-11-22 18:55:02.497289+00	\N
optval_01JDAKMHBG45VHMGJHGK4M03YG	Medium	opt_01JD0KPTYPBG254FXMZPN9N506	\N	2024-11-22 18:55:02.497289+00	2024-11-22 18:55:02.497289+00	\N
optval_01JDAKMHBG923R10GMBF5JVSW1	Large	opt_01JD0KPTYPBG254FXMZPN9N506	\N	2024-11-22 18:55:02.497289+00	2024-11-22 18:55:02.497289+00	\N
optval_01JC6VS50V92WYR9TYHXKQYSJY	Red	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-22 19:09:04.831+00	2024-11-22 19:09:04.827+00
optval_01JC6VS50VTS551J26WN8WVARM	Pink	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-22 19:09:04.831+00	2024-11-22 19:09:04.827+00
optval_01JC6VS50WQQRCQ1HYWHGGPWAS	White	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-22 19:09:04.831+00	2024-11-22 19:09:04.827+00
optval_01JC6VS50WS90P8K2G6YCG3CQP	Mixed	opt_01JC6VS3NF1PS4NTVVFH4ATR3J	\N	2024-11-08 21:44:39.080448+00	2024-11-22 19:09:04.832+00	2024-11-22 19:09:04.827+00
optval_01JDANDPA5040VAQQRSNGYF7EM	Small	opt_01JDANDPA6A2H7355R8XG738C1	\N	2024-11-22 19:26:15.366+00	2024-11-22 19:26:15.366+00	\N
optval_01JDANDPA6PB09X01YP9KD3RV2	Medium	opt_01JDANDPA6A2H7355R8XG738C1	\N	2024-11-22 19:26:15.366+00	2024-11-22 19:26:15.366+00	\N
optval_01JDANDPA6FCJ2TKBTXZMDTW8M	Large	opt_01JDANDPA6A2H7355R8XG738C1	\N	2024-11-22 19:26:15.366+00	2024-11-22 19:26:15.366+00	\N
optval_01JDAN74Z8Z3MRCVP90AM8ZC81	Default option value	opt_01JDAN74Z6SKA7YRJP6WJ20A05	\N	2024-11-22 19:22:40.977117+00	2024-11-22 19:27:00.421+00	2024-11-22 19:27:00.419+00
optval_01JDANG4WD2Y3TSA53QCD56HMA	Classic paper wrap	opt_01JDANG4WDYM1G7RVF4VTJTMR2	\N	2024-11-22 19:27:35.821+00	2024-11-22 19:27:35.821+00	\N
optval_01JDANG4WDGPQ6FHDJWEHP8WGN	Ribbon-tied with rustic burlap	opt_01JDANG4WDYM1G7RVF4VTJTMR2	\N	2024-11-22 19:27:35.821+00	2024-11-22 19:27:35.821+00	\N
optval_01JDANG4WDBN3GW7PHTV8HCN0Q	Luxury wrap with silk ribbon	opt_01JDANG4WDYM1G7RVF4VTJTMR2	\N	2024-11-22 19:27:35.821+00	2024-11-22 19:27:35.821+00	\N
optval_01JDAP8DTYY61JV0DCPW1XJ0SC	Small	opt_01JDAP8DTXBEY03RKA48X7DE57	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N
optval_01JDAP8DTYVXQGZXSW3HARJQQ7	Medium	opt_01JDAP8DTXBEY03RKA48X7DE57	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N
optval_01JDAP8DTYB7FKTJVX938MPZ0S	Large	opt_01JDAP8DTXBEY03RKA48X7DE57	\N	2024-11-22 19:40:51.411409+00	2024-11-22 19:40:51.411409+00	\N
optval_01JDAPJSS8R71J2R8WHZVSX3DS	Medium	opt_01JDANWN3B2W8ES48B2GTSA6ZS	\N	2024-11-22 19:46:31.329045+00	2024-11-22 19:46:31.329045+00	\N
optval_01JDANWN3D0SPVS2DJRK5AF5XP	Small	opt_01JDANWN3B2W8ES48B2GTSA6ZS	\N	2024-11-22 19:34:25.635948+00	2024-11-22 19:34:25.635948+00	\N
optval_01JDANWN3DFG9BQK5AXCYEKVQ6	Large	opt_01JDANWN3B2W8ES48B2GTSA6ZS	\N	2024-11-22 19:34:25.635948+00	2024-11-22 19:34:25.635948+00	\N
optval_01JDAVWNDSP7VW9FN0Z4MPPTYA	Small	opt_01JDAVWNDSH1M03TGZX76G9GFM	\N	2024-11-22 21:19:17.433+00	2024-11-22 21:19:17.433+00	\N
optval_01JDAVWNDSCGFD6AFBR88EZREQ	Medium	opt_01JDAVWNDSH1M03TGZX76G9GFM	\N	2024-11-22 21:19:17.433+00	2024-11-22 21:19:17.433+00	\N
optval_01JDAVWNDS24XQHP1Y3EWNQTBA	Large	opt_01JDAVWNDSH1M03TGZX76G9GFM	\N	2024-11-22 21:19:17.433+00	2024-11-22 21:19:17.433+00	\N
optval_01JC6VS50W9V131W8SVS2ZD343	Classic paper wrap	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-22 21:23:10.536+00	2024-11-22 21:23:10.532+00
optval_01JC6VS50XSJ7G6D808CA70B1W	Ribbon-tied with rustic burlap	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-22 21:23:10.536+00	2024-11-22 21:23:10.532+00
optval_01JC6VS50XKHHH0PY9DB37989C	Luxury wrap with silk ribbon	opt_01JC6VS3NGF8EQTMCGY8SYXKVT	\N	2024-11-08 21:44:39.080448+00	2024-11-22 21:23:10.536+00	2024-11-22 21:23:10.532+00
optval_01JDAW5QYAKBPZNEW6JCV09JMB	Classic paper wrap	opt_01JDAW5QYBVVE3Y0F08KKNY4V8	\N	2024-11-22 21:24:14.923+00	2024-11-22 21:24:14.923+00	\N
optval_01JDAW5QYARN3WTEDZXWZJ0MNE	Ribbon-tied with rustic burlap	opt_01JDAW5QYBVVE3Y0F08KKNY4V8	\N	2024-11-22 21:24:14.923+00	2024-11-22 21:24:14.923+00	\N
optval_01JDAW5QYBA23B42AYEN47M2AJ	Luxury wrap with silk ribbon	opt_01JDAW5QYBVVE3Y0F08KKNY4V8	\N	2024-11-22 21:24:14.923+00	2024-11-22 21:24:14.923+00	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01JBYPAX9MZD59BMNW71AXBF23	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9KF0FP6NPBC4VA8BFK	2024-11-05 17:35:54+00	2024-11-05 17:35:54+00	\N
prod_01JC6VS1S74ACE8RN57D8P4VD1	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JC6VSBVWKWX6JS0R2VKD036T	2024-11-08 21:44:50+00	2024-11-08 21:44:50+00	\N
prod_01JBYPAX9KTG1VRTK059RV2VWZ	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9JRKNRKZ1GSRC2R8GA	2024-11-05 17:35:54+00	2024-11-08 22:17:49+00	2024-11-08 22:17:49+00
prod_01JBYPAX9MM5R7BNNF72RKRWEY	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9MT97HEKTS3WJ68K5W	2024-11-05 17:35:54+00	2024-11-08 22:18:14+00	2024-11-08 22:18:14+00
prod_01JBYPAX9MQZEWFQ67XEC5DTF3	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JBYPBD9KBCEFJ64ZW159M894	2024-11-05 17:35:54+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
prod_01JD0JMM2QYTH0T2H8B8FD6D6M	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JD0JMM4W7XXVWYKHETKXRGB7	2024-11-18 21:25:12+00	2024-11-18 21:25:12+00	\N
prod_01JD0KPTXF4EH9H01K5WQNKBG6	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JD0KPV05SJW4NJWZ06X2EQ8Z	2024-11-18 21:43:54+00	2024-11-18 21:43:54+00	\N
prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JD0NJ378RC2HS3AFSBM50AAE	2024-11-18 22:16:15+00	2024-11-18 22:16:15+00	\N
prod_01JDAN74YNGD7F94RCYVMYT9AF	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JDAN74ZMM7PADXQTMPNVY2NC	2024-11-22 19:22:41+00	2024-11-22 19:22:41+00	\N
prod_01JDANWN36T6E3320AVST9Y9FW	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JDANWN3RAWC0HMHWNYV21T8J	2024-11-22 19:34:26+00	2024-11-22 19:34:26+00	\N
prod_01JDAP8DTNBE48Z55TMVER4V8J	sc_01JBYPA6S9ZG068M4VFJQNC33B	prodsc_01JDAP8DV90AHZJF0JRZXESDEV	2024-11-22 19:40:51+00	2024-11-22 19:40:51+00	\N
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptag_01JCE3PMFMAGK79WN57QGK7C8R	flower	\N	2024-11-11 17:17:49.94+00	2024-11-11 17:17:49.94+00	\N
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
prod_01JC6VS1S74ACE8RN57D8P4VD1	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JD0JMM2QYTH0T2H8B8FD6D6M	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JD0KPTXF4EH9H01K5WQNKBG6	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JDAN74YNGD7F94RCYVMYT9AF	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JDANWN36T6E3320AVST9Y9FW	ptag_01JCE3PMFMAGK79WN57QGK7C8R
prod_01JDAP8DTNBE48Z55TMVER4V8J	ptag_01JCE3PMFMAGK79WN57QGK7C8R
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MZD59BMNW71AXBF23	2024-11-05 17:35:55.175+00	2024-11-05 17:35:55.175+00	\N
variant_01JC6VSD8P772HFKT6DZSZ5N5Z	Small (12 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PN2PTSVWFDAE1E441	Medium (24 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PDVPSAQMNSG8DVTGM	Large (36 roses) / Pink / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8P74MGBPZFDT9CW52G	Small (12 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PXRADW9HHCGAAD7FG	Medium (24 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PHJZSQ1RBV989AXRR	Large (36 roses) / White / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8PKPYWBF361CAY0X9J	Small (12 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Q02VSYREYC15C1MEM	Medium (24 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8QMVYQBJ6HXBA6QQ6R	Large (36 roses) / Mixed / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8R8AT4FC9MQYRZXN8D	Small (12 roses) / Pink / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8RZWPF0E69A0ABPH8F	Small (12 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8S5501MRHX4J4RG5AZ	Small (12 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8SYHEBZ0KMZFBRN3ZT	Medium (24 roses) / Red / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8TCA90EXZ05SDJHJ7K	Medium (24 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8TH1F446A21F39E757	Medium (24 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8VE6HY0E8HJ97BHAWH	Large (36 roses) / Red / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8VR9VYX9Q9NB775AGH	Large (36 roses) / White / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8WNJJ8221A0B7J4CPF	Large (36 roses) / Mixed / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8WB4P91GB8RD6VVC5B	Small (12 roses) / Red / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8X15DMR213E5MAJ2HT	Small (12 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8X7FBRK812ZYD0235G	Small (12 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JBYPBE90Y0XBX14X6WRTQFRX	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.174+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE94FG87CR5AG1W9E1Q9	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE94W3J0DR77V2T1NRZD	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE94X1RY6QPC9D54E12H	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JBYPBE95B901P7H677QKWZNW	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MM5R7BNNF72RKRWEY	2024-11-05 17:35:55.175+00	2024-11-08 22:18:15.289+00	2024-11-08 22:18:13.744+00
variant_01JC6VSD8YQTE3HB8EFGZTT9SS	Medium (24 roses) / Pink / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8YY2CAX8KKCH2J4XAP	Medium (24 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Y0MSYV0G4KE4YTWPP	Medium (24 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD9043GNQ97MGMJBT4HX	Large (36 roses) / Pink / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8NKFC71R3ZXV09T13S	Medium / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	Large / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8NN7D5QF2BET7MZNAK	Small / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.234+00	2024-11-08 21:44:51.234+00	\N
variant_01JC6VSD8QC934X4R9T229VCD5	Small / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	Medium / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8V633FNXPCW33RA207	Large / Ribbon-tied with rustic burlap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8W75WP4W76WCP649V1	Small / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8XNX2814PPVRHM4MBV	Medium / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	Large / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD919HA7JS3T8EXZBSWX	Large (36 roses) / White / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.235+00	2024-11-08 21:44:51.235+00	\N
variant_01JC6VSD91DBJVHNC4KFJ9C3PM	Large (36 roses) / Mixed / Luxury wrap with silk ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JC6VS1S74ACE8RN57D8P4VD1	2024-11-08 21:44:51.236+00	2024-11-08 21:44:51.236+00	\N
variant_01JBYPBE918XY9ZYK9G7MNV363	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE916PJQVRTYSQH4HPHN	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE91TCGBFJ0HECT809G1	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE921XBK4BG0NSA18CSC	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92GK6DC7ZQ09CBFA5V	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92CN934BR1AVBXK686	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE92AWZRSMTER2T555QG	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9KTG1VRTK059RV2VWZ	2024-11-05 17:35:55.175+00	2024-11-08 22:17:52.387+00	2024-11-08 22:17:48.911+00
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-14 21:19:44.023+00	2024-11-14 21:19:44.009+00
variant_01JBYPBE93969VX8HEZJCR4NNP	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-14 21:19:44.023+00	2024-11-14 21:19:44.009+00
variant_01JBYPBE946EJBD22K26AH4183	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-14 21:19:44.023+00	2024-11-14 21:19:44.009+00
variant_01JBYPBE94YNRC1A69J20EDDR8	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JBYPAX9MQZEWFQ67XEC5DTF3	2024-11-05 17:35:55.175+00	2024-11-14 21:19:44.023+00	2024-11-14 21:19:44.009+00
variant_01JD0JMM65M71H6B3ACZNMRMFZ	Small	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0JMM2QYTH0T2H8B8FD6D6M	2024-11-18 21:25:12.52+00	2024-11-18 21:25:12.52+00	\N
variant_01JD0JMM66B95YFPGAZVC92CYH	Medium	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0JMM2QYTH0T2H8B8FD6D6M	2024-11-18 21:25:12.521+00	2024-11-18 21:25:12.521+00	\N
variant_01JD0JMM66Z9GCEPQ1HG3Q8BRE	Large	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0JMM2QYTH0T2H8B8FD6D6M	2024-11-18 21:25:12.521+00	2024-11-18 21:25:12.521+00	\N
variant_01JD0NJ37JZF3H5WSH06QVM32B	Default option value	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0NJ36RDFA9ATA4AZ8BWYJ9	2024-11-18 22:16:15.346+00	2024-11-18 22:16:15.346+00	\N
variant_01JDANWN41DCV3G9RRK8062M9R	Small	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDANWN36T6E3320AVST9Y9FW	2024-11-22 19:34:25.665+00	2024-11-22 19:34:25.665+00	\N
variant_01JDANWN41K5WPAKX75APYH47A	Large	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDANWN36T6E3320AVST9Y9FW	2024-11-22 19:34:25.666+00	2024-11-22 19:34:25.666+00	\N
variant_01JDAP8DVKATV2S8DCP8AJVEGM	Small	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAP8DTNBE48Z55TMVER4V8J	2024-11-22 19:40:51.444+00	2024-11-22 19:40:51.444+00	\N
variant_01JDAP8DVKNC224PSQR8ZWNA2S	Medium	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAP8DTNBE48Z55TMVER4V8J	2024-11-22 19:40:51.444+00	2024-11-22 19:40:51.444+00	\N
variant_01JDAP8DVKXG3ZFCCVSRX513FN	Large	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAP8DTNBE48Z55TMVER4V8J	2024-11-22 19:40:51.444+00	2024-11-22 19:40:51.444+00	\N
variant_01JDAN750A1ABZWEY8MY0HNXBD	Default option value	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:22:41.034+00	2024-11-22 19:44:33.148+00	2024-11-22 19:44:33.148+00
variant_01JDANWN4117Q4338TDXQMQZTW	Mediu	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDANWN36T6E3320AVST9Y9FW	2024-11-22 19:34:25.665+00	2024-11-22 19:34:25.665+00	\N
variant_01JDAPNJHWZVKWNHQVG1N3MZ8N	Small / Classic paper wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:48:02.237+00	2024-11-22 19:48:02.237+00	\N
variant_01JDAPPVA9NMPT83ARHV1773NB	Small / Luxury wrap	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:48:43.977+00	2024-11-22 19:48:43.977+00	\N
variant_01JDAPQWF298E98RJWQEF12JCD	Small / Ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:49:17.923+00	2024-11-22 19:49:17.923+00	\N
variant_01JDAPRVZ35E0MYS7JZZQHK062	Medium / classic	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:49:50.179+00	2024-11-22 19:49:50.179+00	\N
variant_01JDAPSJMB80MGC6CRXA86YPJ3	Medium / 	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:50:13.388+00	2024-11-22 19:50:13.388+00	\N
variant_01JDAPTCTDM1YQ2RDZ1QHDKE9P	Medium / Ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:50:40.205+00	2024-11-22 19:50:40.205+00	\N
variant_01JDAPVNW8MHF38626JE8WHC3S	Large / Classic	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:51:22.249+00	2024-11-22 19:51:22.249+00	\N
variant_01JDAPWAG95EMMY5BP1AXND8SW	Large / Luxury	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:51:43.369+00	2024-11-22 19:51:43.369+00	\N
variant_01JDAPWXTBBWTMNBZZNE6WJWGC	Large / Ribbon	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JDAN74YNGD7F94RCYVMYT9AF	2024-11-22 19:52:03.147+00	2024-11-22 19:52:03.147+00	\N
variant_01JD0KPV29DYV5ZKHCRW7EE3VA	Medium (11 pieces)	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0KPTXF4EH9H01K5WQNKBG6	2024-11-18 21:43:53.688+00	2024-11-18 21:43:53.688+00	\N
variant_01JD0KPV29N0JVQRT4R6PRBMPB	Small (5 pieces)	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0KPTXF4EH9H01K5WQNKBG6	2024-11-18 21:43:53.687+00	2024-11-18 21:43:53.687+00	\N
variant_01JD0KPV2A6HYYA2Z6B7J67E2X	Large (19 pieces)	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01JD0KPTXF4EH9H01K5WQNKBG6	2024-11-18 21:43:53.688+00	2024-11-18 21:43:53.688+00	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	iitem_01JBYPBK4SDN3PW82TP0GWXJ7P	pvitem_01JBYPBMGRTJ50TJ54BKJJGGH1	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	iitem_01JBYPBK4TFGBRW15DF20VZY6B	pvitem_01JBYPBMGRT855K922F0AJ9HBY	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	iitem_01JBYPBK4TF0GS9ZFSHHPWK09N	pvitem_01JBYPBMGRMD5DRV94MXXGRW4V	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	iitem_01JBYPBK4TW63S8CF5JAG3P135	pvitem_01JBYPBMGR57CAW1VB8QE2F9MD	1	2024-11-05 17:36:01+00	2024-11-05 17:36:01+00	\N
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
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	iitem_01JBYPBK4T43KYXWP8G8P59Q5A	pvitem_01JBYPBMGREW3E5S7A2XMNSNJ1	1	2024-11-05 17:36:01+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE93969VX8HEZJCR4NNP	iitem_01JBYPBK4T1R3QB4XWG2X7J9SC	pvitem_01JBYPBMGRVHRJSKEFT5XC8QEP	1	2024-11-05 17:36:01+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE946EJBD22K26AH4183	iitem_01JBYPBK4TB145EVQ7DXTTV2MP	pvitem_01JBYPBMGRPSQFBX37SRVYKM1S	1	2024-11-05 17:36:01+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE94YNRC1A69J20EDDR8	iitem_01JBYPBK4T1QBXZ6ZCWH0JVEN6	pvitem_01JBYPBMGS39BCSXCBXG580BQC	1	2024-11-05 17:36:01+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: yourusername
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
variant_01JC6VSD8NN7D5QF2BET7MZNAK	optval_01JC6VS50W9V131W8SVS2ZD343
variant_01JC6VSD8NKFC71R3ZXV09T13S	optval_01JC6VS50W9V131W8SVS2ZD343
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
variant_01JC6VSD8W75WP4W76WCP649V1	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50WQQRCQ1HYWHGGPWAS
variant_01JC6VSD8X15DMR213E5MAJ2HT	optval_01JC6VS50XKHHH0PY9DB37989C
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50TC1QBR8627E1XQJRP
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50WS90P8K2G6YCG3CQP
variant_01JC6VSD8X7FBRK812ZYD0235G	optval_01JC6VS50XKHHH0PY9DB37989C
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
variant_01JD0JMM65M71H6B3ACZNMRMFZ	optval_01JD0JMM45DNC8E0YTV5S76A09
variant_01JD0JMM66B95YFPGAZVC92CYH	optval_01JD0JMM460WYRT6BKR23FERRR
variant_01JD0JMM66Z9GCEPQ1HG3Q8BRE	optval_01JD0JMM461KXPWVDJQJ5KM82N
variant_01JD0NJ37JZF3H5WSH06QVM32B	optval_01JD0NJ372870342EQ9EZNR9C5
variant_01JDAN750A1ABZWEY8MY0HNXBD	optval_01JDAN74Z8Z3MRCVP90AM8ZC81
variant_01JDANWN41DCV3G9RRK8062M9R	optval_01JDANWN3D0SPVS2DJRK5AF5XP
variant_01JDANWN41K5WPAKX75APYH47A	optval_01JDANWN3DFG9BQK5AXCYEKVQ6
variant_01JDAP8DVKATV2S8DCP8AJVEGM	optval_01JDAP8DTYY61JV0DCPW1XJ0SC
variant_01JDAP8DVKNC224PSQR8ZWNA2S	optval_01JDAP8DTYVXQGZXSW3HARJQQ7
variant_01JDAP8DVKXG3ZFCCVSRX513FN	optval_01JDAP8DTYB7FKTJVX938MPZ0S
variant_01JDANWN4117Q4338TDXQMQZTW	optval_01JDAPJSS8R71J2R8WHZVSX3DS
variant_01JDAPNJHWZVKWNHQVG1N3MZ8N	optval_01JDANDPA5040VAQQRSNGYF7EM
variant_01JDAPNJHWZVKWNHQVG1N3MZ8N	optval_01JDANG4WD2Y3TSA53QCD56HMA
variant_01JDAPPVA9NMPT83ARHV1773NB	optval_01JDANDPA5040VAQQRSNGYF7EM
variant_01JDAPPVA9NMPT83ARHV1773NB	optval_01JDANG4WDBN3GW7PHTV8HCN0Q
variant_01JDAPQWF298E98RJWQEF12JCD	optval_01JDANDPA5040VAQQRSNGYF7EM
variant_01JDAPQWF298E98RJWQEF12JCD	optval_01JDANG4WDGPQ6FHDJWEHP8WGN
variant_01JDAPRVZ35E0MYS7JZZQHK062	optval_01JDANDPA6PB09X01YP9KD3RV2
variant_01JDAPRVZ35E0MYS7JZZQHK062	optval_01JDANG4WD2Y3TSA53QCD56HMA
variant_01JDAPSJMB80MGC6CRXA86YPJ3	optval_01JDANDPA6PB09X01YP9KD3RV2
variant_01JDAPSJMB80MGC6CRXA86YPJ3	optval_01JDANG4WDBN3GW7PHTV8HCN0Q
variant_01JDAPTCTDM1YQ2RDZ1QHDKE9P	optval_01JDANDPA6PB09X01YP9KD3RV2
variant_01JDAPTCTDM1YQ2RDZ1QHDKE9P	optval_01JDANG4WDGPQ6FHDJWEHP8WGN
variant_01JDAPVNW8MHF38626JE8WHC3S	optval_01JDANDPA6FCJ2TKBTXZMDTW8M
variant_01JDAPVNW8MHF38626JE8WHC3S	optval_01JDANG4WD2Y3TSA53QCD56HMA
variant_01JDAPWAG95EMMY5BP1AXND8SW	optval_01JDANDPA6FCJ2TKBTXZMDTW8M
variant_01JDAPWAG95EMMY5BP1AXND8SW	optval_01JDANG4WDBN3GW7PHTV8HCN0Q
variant_01JDAPWXTBBWTMNBZZNE6WJWGC	optval_01JDANDPA6FCJ2TKBTXZMDTW8M
variant_01JDAPWXTBBWTMNBZZNE6WJWGC	optval_01JDANG4WDGPQ6FHDJWEHP8WGN
variant_01JD0KPV29DYV5ZKHCRW7EE3VA	optval_01JDAKMHBG45VHMGJHGK4M03YG
variant_01JD0KPV29N0JVQRT4R6PRBMPB	optval_01JDAKMHBGBPBAWVJJV97789SG
variant_01JD0KPV2A6HYYA2Z6B7J67E2X	optval_01JDAKMHBG923R10GMBF5JVSW1
variant_01JC6VSD8N21NVEJ2QGNVJR9KP	optval_01JDAVWNDS24XQHP1Y3EWNQTBA
variant_01JC6VSD8NKFC71R3ZXV09T13S	optval_01JDAVWNDSCGFD6AFBR88EZREQ
variant_01JC6VSD8NN7D5QF2BET7MZNAK	optval_01JDAVWNDSP7VW9FN0Z4MPPTYA
variant_01JC6VSD8QC934X4R9T229VCD5	optval_01JDAVWNDSP7VW9FN0Z4MPPTYA
variant_01JC6VSD8SJ5JYAN4WZSEHH0FK	optval_01JDAVWNDSCGFD6AFBR88EZREQ
variant_01JC6VSD8V633FNXPCW33RA207	optval_01JDAVWNDS24XQHP1Y3EWNQTBA
variant_01JC6VSD8W75WP4W76WCP649V1	optval_01JDAVWNDSP7VW9FN0Z4MPPTYA
variant_01JC6VSD8XNX2814PPVRHM4MBV	optval_01JDAVWNDSCGFD6AFBR88EZREQ
variant_01JC6VSD8Y57K7R4ENAGBWZTY2	optval_01JDAVWNDS24XQHP1Y3EWNQTBA
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JBYPBE93PM2NXG8HQFB6D16H	pset_01JBYPBN43WFEPMS6Y68FV6BN5	pvps_01JBYPBPCV92J2B4BMB2HDJZ82	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93ZZZWF21FA1W7WB5C	pset_01JBYPBN43X9Y2563SPBB2G3JQ	pvps_01JBYPBPCVK98D1QFN3HQ0MQFR	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE93GJCNSA5BFXD54W3K	pset_01JBYPBN4443WRQDKTZEE411C4	pvps_01JBYPBPCVQYHEGK7J77MCHCGJ	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
variant_01JBYPBE931101X6XAQC2W1JRV	pset_01JBYPBN44ZY6349NTPX34KKY2	pvps_01JBYPBPCV69MH51K6NSRW9XQS	2024-11-05 17:36:03+00	2024-11-05 17:36:03+00	\N
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
variant_01JBYPBE93E2FFVBF2CXEZ1YVZ	pset_01JBYPBN45BKME4FTW7J471GJH	pvps_01JBYPBPCV0Q9WAMM1YG2ACDYE	2024-11-05 17:36:03+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE93969VX8HEZJCR4NNP	pset_01JBYPBN45Q2XGJ7C6180MYGJ6	pvps_01JBYPBPCVV2JE32NV43XKPDP7	2024-11-05 17:36:03+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE946EJBD22K26AH4183	pset_01JBYPBN45JZZH804E5GQ9GMFW	pvps_01JBYPBPCVK7HDJW9P62NNW3X0	2024-11-05 17:36:03+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JBYPBE94YNRC1A69J20EDDR8	pset_01JBYPBN4655WQ418G1D71R7TT	pvps_01JBYPBPCVC2MAQB2J3AR9HT6E	2024-11-05 17:36:03+00	2024-11-14 21:19:44+00	2024-11-14 21:19:44+00
variant_01JD0JMM65M71H6B3ACZNMRMFZ	pset_01JD0JMM86VY1VBW25NWA6Z8FN	pvps_01JD0JMM9C2FXYKAZ8CW0JWCN5	2024-11-18 21:25:13+00	2024-11-18 21:25:13+00	\N
variant_01JD0JMM66B95YFPGAZVC92CYH	pset_01JD0JMM87GHSS7805REWBFF3D	pvps_01JD0JMM9DBFPKS63VP7JPEPTE	2024-11-18 21:25:13+00	2024-11-18 21:25:13+00	\N
variant_01JD0JMM66Z9GCEPQ1HG3Q8BRE	pset_01JD0JMM88PMD942KV5FJGYP0C	pvps_01JD0JMM9DE52M3X2NMHEHPNF1	2024-11-18 21:25:13+00	2024-11-18 21:25:13+00	\N
variant_01JD0KPV29N0JVQRT4R6PRBMPB	pset_01JD0KPV4B452532XT7KE2RWGD	pvps_01JD0KPV5CZ768MM9WSBCJZCSC	2024-11-18 21:43:54+00	2024-11-18 21:43:54+00	\N
variant_01JD0KPV29DYV5ZKHCRW7EE3VA	pset_01JD0KPV4CB55NA89T3N8F5PBP	pvps_01JD0KPV5C3QGQMZBW30TF0KQ0	2024-11-18 21:43:54+00	2024-11-18 21:43:54+00	\N
variant_01JD0KPV2A6HYYA2Z6B7J67E2X	pset_01JD0KPV4DD32K9J21SHNEJGJF	pvps_01JD0KPV5C29DMVEYX0V2BQJG8	2024-11-18 21:43:54+00	2024-11-18 21:43:54+00	\N
variant_01JD0NJ37JZF3H5WSH06QVM32B	pset_01JD0NJ382VCAN1949G2Y62R9Z	pvps_01JD0NJ38AEP76R5GX7CPGPF7P	2024-11-18 22:16:15+00	2024-11-18 22:16:15+00	\N
variant_01JDANWN41DCV3G9RRK8062M9R	pset_01JDANWN4D5FYZBGVM87XEBV6Z	pvps_01JDANWN4QA80T3Q6EFQTZZYTV	2024-11-22 19:34:26+00	2024-11-22 19:34:26+00	\N
variant_01JDANWN4117Q4338TDXQMQZTW	pset_01JDANWN4E2PX5XKZX6T16XYYZ	pvps_01JDANWN4Q41C463Y5962BPW71	2024-11-22 19:34:26+00	2024-11-22 19:34:26+00	\N
variant_01JDANWN41K5WPAKX75APYH47A	pset_01JDANWN4EXDDT303CVMG69RQR	pvps_01JDANWN4QE57YY9YKQ8H8YA75	2024-11-22 19:34:26+00	2024-11-22 19:34:26+00	\N
variant_01JDAP8DVKATV2S8DCP8AJVEGM	pset_01JDAP8DWDS0C5G7ZSB82NVRKG	pvps_01JDAP8DWPPANFHBH68HAEDKCQ	2024-11-22 19:40:51+00	2024-11-22 19:40:51+00	\N
variant_01JDAP8DVKNC224PSQR8ZWNA2S	pset_01JDAP8DWDSS7XYBAA1QJEWDEZ	pvps_01JDAP8DWPNDMYR9J4M9QV37XS	2024-11-22 19:40:51+00	2024-11-22 19:40:51+00	\N
variant_01JDAP8DVKXG3ZFCCVSRX513FN	pset_01JDAP8DWEM1JE65W7PESRGATM	pvps_01JDAP8DWPJDKB7B2SZBDY1SKJ	2024-11-22 19:40:51+00	2024-11-22 19:40:51+00	\N
variant_01JDAN750A1ABZWEY8MY0HNXBD	pset_01JDAN750Q7NCG60X8SVJSYZJ5	pvps_01JDAN750YHAFVA0GNZ6T9B94J	2024-11-22 19:22:41+00	2024-11-22 19:44:33+00	2024-11-22 19:44:33+00
variant_01JDAPNJHWZVKWNHQVG1N3MZ8N	pset_01JDAPNJJG111HS794K8R4H9TR	pvps_01JDAPNJJVCRDZXNYSBW56QRW5	2024-11-22 19:48:02+00	2024-11-22 19:48:02+00	\N
variant_01JDAPPVA9NMPT83ARHV1773NB	pset_01JDAPPVAVWW5AKPJB0MRSHGC2	pvps_01JDAPPVB2FMG0XRXS65F87ZWS	2024-11-22 19:48:44+00	2024-11-22 19:48:44+00	\N
variant_01JDAPQWF298E98RJWQEF12JCD	pset_01JDAPQWFMNF1W5P6GY8F4GEY8	pvps_01JDAPQWFW40GTS80655W0MNND	2024-11-22 19:49:18+00	2024-11-22 19:49:18+00	\N
variant_01JDAPRVZ35E0MYS7JZZQHK062	pset_01JDAPRVZP3FZC0PVDEF56309P	pvps_01JDAPRVZV64HAE14W4DA8PMPP	2024-11-22 19:49:50+00	2024-11-22 19:49:50+00	\N
variant_01JDAPSJMB80MGC6CRXA86YPJ3	pset_01JDAPSJMYA9XX41HBGBSQPQD1	pvps_01JDAPSJN4XZRT2MSNG4C758BH	2024-11-22 19:50:13+00	2024-11-22 19:50:13+00	\N
variant_01JDAPTCTDM1YQ2RDZ1QHDKE9P	pset_01JDAPTCV2WMYF7GR6Q8EWC6K2	pvps_01JDAPTCV95DVYVMHJZYQ5A1HN	2024-11-22 19:50:40+00	2024-11-22 19:50:40+00	\N
variant_01JDAPVNW8MHF38626JE8WHC3S	pset_01JDAPVNWVW7NV96V816R7A78E	pvps_01JDAPVNX26VT4MAANC1465PZH	2024-11-22 19:51:22+00	2024-11-22 19:51:22+00	\N
variant_01JDAPWAG95EMMY5BP1AXND8SW	pset_01JDAPWAGTBJR5E0EV07WJAEDN	pvps_01JDAPWAGZ6BNX09R205AWGD2T	2024-11-22 19:51:43+00	2024-11-22 19:51:43+00	\N
variant_01JDAPWXTBBWTMNBZZNE6WJWGC	pset_01JDAPWXTP938JT0J8SDAD44N0	pvps_01JDAPWXTWYWNGJX2JK95E7R34	2024-11-22 19:52:03+00	2024-11-22 19:52:03+00	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at) FROM stdin;
provid_01JBYPDQQN2F3V4T5WZAGP7Z8A	lopliok@gmail.com	emailpass	authid_01JBYPDQQPSG5JH0M4HRE2GMB8	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAYXV7lu9RmbhCZXdZ0ve2HMts8Nw/khPFe6YJEnHvpOfoKCoSMfMhkuiKGBtJLC7K8exV3WAI33BmWVryG+DIylu22LOJDZI/gMFdaZIZujq"}	2024-11-05 17:37:10.39+00	2024-11-05 17:37:10.39+00
provid_01JC1M2DX63XKVXZQ5W7S4KX46	test@gmail.com	emailpass	authid_01JC1M2DX70H1QK4D6G25HQM8E	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAZdcZdUeLuVce+PFwLj1/ZhabJ9/NoYUo8zO25Up7xHZRIttL4FtoGudo72eLwwbJ0NyI7lXZcjupp4JtonMu3fTgW+MaFvJ/UsZst9AfKLg"}	2024-11-06 20:53:46.023+00	2024-11-06 20:53:46.023+00
provid_01JC1MRK1QK0ZJNHWM3T1ZJYF7	lisan2167@gmail.com	emailpass	authid_01JC1MRK1QEFPYC37BQ3WM0PWY	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAaYna3Hqv+L7OZVwiCAjFtIfroYwBJ8tfhqJ545HdJRyyWPmQp1sXnZ/usOFAvI7mAVBpkzthYVoYJTWUMHJbde0x8CRylSj56tmKci5J3Fq"}	2024-11-06 21:05:52.183+00	2024-11-06 21:05:52.183+00
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01JBYPASJ7CX64V2V1ST9YSV90	sc_01JBYPA6S9ZG068M4VFJQNC33B	pksc_01JBYPATBSRM36F5CDG3769VF8	2024-11-05 17:35:35+00	2024-11-05 17:35:35+00	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01JBYPADWSXFGTDVY7VEGD8GDQ	Europe	eur	\N	2024-11-05 17:35:22.215+00	2024-11-05 17:35:22.215+00	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: yourusername
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
dk	dnk	208	DENMARK	Denmark	\N	\N	2024-11-05 17:34:57.727+00	2024-11-21 19:19:18.21+00	\N
fr	fra	250	FRANCE	France	\N	\N	2024-11-05 17:34:57.727+00	2024-11-21 19:19:18.21+00	\N
de	deu	276	GERMANY	Germany	\N	\N	2024-11-05 17:34:57.727+00	2024-11-21 19:19:18.21+00	\N
it	ita	380	ITALY	Italy	\N	\N	2024-11-05 17:34:57.727+00	2024-11-21 19:19:18.21+00	\N
es	esp	724	SPAIN	Spain	\N	\N	2024-11-05 17:34:57.729+00	2024-11-21 19:19:18.21+00	\N
se	swe	752	SWEDEN	Sweden	\N	\N	2024-11-05 17:34:57.729+00	2024-11-21 19:19:18.21+00	\N
pl	pol	616	POLAND	Poland	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	2024-11-05 17:34:57.728+00	2024-11-21 19:19:18.217+00	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	\N	\N	2024-11-05 17:34:57.729+00	2024-11-21 19:19:18.21+00	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01JBYPADWSXFGTDVY7VEGD8GDQ	pp_system_default	regpp_01JBYPAFFZCBBART4RZJ69E4K7	2024-11-05 17:35:23+00	2024-11-05 17:35:23+00	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
resitem_01JC1NZPG7J41K2QGCAXF53RK3	2024-11-06 21:27:13.862+00	2024-11-08 22:17:36.718+00	2024-11-08 22:17:30.584+00	ordli_01JC1NZH288S4WS3MJ4RG4FP3X	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	2	\N	\N	\N	\N	iitem_01JBYPBK4SQPXQPEXZJBRG4VPC	f	{"value": "2", "precision": 20}
resitem_01JC1NZPG7AB052ZR4CMBT2N17	2024-11-06 21:27:13.862+00	2024-11-08 22:17:41.097+00	2024-11-08 22:17:30.584+00	ordli_01JC1NZH28MV8MKF2EYK723HMN	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	1	\N	\N	\N	\N	iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS	f	{"value": "1", "precision": 20}
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01JBYPA6S9ZG068M4VFJQNC33B	Default Sales Channel	Created by Medusa	f	\N	2024-11-05 17:35:14.729+00	2024-11-05 17:35:14.73+00	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01JBYPA6S9ZG068M4VFJQNC33B	sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	scloc_01JBYPARZZZDFZYGB6WJRDN6F0	2024-11-05 17:35:33+00	2024-11-05 17:35:33+00	\N
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01JBYPAJPF5JJQD2G692VYJY3F	Europe	\N	fuset_01JBYPAJPFXBEPZA9QMJZEE55N	2024-11-05 17:35:26.928+00	2024-11-05 17:35:26.928+00	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01JBYPANQPHC24PMZKPRMX0FRG	Standard Shipping	flat	serzo_01JBYPAJPF5JJQD2G692VYJY3F	sp_01JBYPAJ3696BYX7PWFDW67YPJ	manual_manual	\N	\N	sotype_01JBYPANQMCBWXCPXE7D18V3PB	2024-11-05 17:35:30.039+00	2024-11-05 17:35:30.039+00	\N
so_01JBYPANQQ3Z5W0C1FCWNESSJX	Express Shipping	flat	serzo_01JBYPAJPF5JJQD2G692VYJY3F	sp_01JBYPAJ3696BYX7PWFDW67YPJ	manual_manual	\N	\N	sotype_01JBYPANQP6TKKEZ6GC16V1R8W	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01JBYPANQPHC24PMZKPRMX0FRG	pset_01JBYPAPZ2HAEWHH400PK8M6GF	sops_01JBYPARCR4SY85WZK56ZNH244	2024-11-05 17:35:32+00	2024-11-05 17:35:32+00	\N
so_01JBYPANQQ3Z5W0C1FCWNESSJX	pset_01JBYPAPZ336WJ0KEYPADK7KMW	sops_01JBYPARCSXKNYRGAB01QAAAGF	2024-11-05 17:35:32+00	2024-11-05 17:35:32+00	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01JBYPANQNZHG8EMVHG0JPKXWJ	enabled_in_store	eq	"\\"true\\""	so_01JBYPANQPHC24PMZKPRMX0FRG	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPGTX4R1SB6G851BJT	is_return	eq	"\\"false\\""	so_01JBYPANQPHC24PMZKPRMX0FRG	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPDQ7V4DDVFJE0FMWD	enabled_in_store	eq	"\\"true\\""	so_01JBYPANQQ3Z5W0C1FCWNESSJX	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
sorul_01JBYPANQPCKC8Q2BCA9EP9CCB	is_return	eq	"\\"false\\""	so_01JBYPANQQ3Z5W0C1FCWNESSJX	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01JBYPANQMCBWXCPXE7D18V3PB	Standard	Ship in 2-3 days.	standard	2024-11-05 17:35:30.039+00	2024-11-05 17:35:30.039+00	\N
sotype_01JBYPANQP6TKKEZ6GC16V1R8W	Express	Ship in 24 hours.	express	2024-11-05 17:35:30.04+00	2024-11-05 17:35:30.04+00	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01JBYPAJ3696BYX7PWFDW67YPJ	Default	default	\N	2024-11-05 17:35:26.311+00	2024-11-05 17:35:26.311+00	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01JBYPAGPDXNDTJ03TW9WVFKSV	2024-11-05 17:35:24.877+00	2024-11-05 17:35:24.877+00	\N	European Warehouse	laddr_01JBYPAGPC1A9VJQX7M7KB5190	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01JBYPAGPC1A9VJQX7M7KB5190	2024-11-05 17:35:24.877+00	2024-11-05 17:35:24.877+00	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01JBYPA7JD468QVY91ZAGTD63M	Boutique Camellia	sc_01JBYPA6S9ZG068M4VFJQNC33B	reg_01JBYPADWSXFGTDVY7VEGD8GDQ	\N	\N	2024-11-05 17:35:15.284367+00	2024-11-05 17:35:15.284367+00	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01JD82HQH1SCCAVAHGN3DP9AQK	eur	t	store_01JBYPA7JD468QVY91ZAGTD63M	2024-11-21 19:17:55.868222+00	2024-11-21 19:17:55.868222+00	\N
stocur_01JD82HQH12BKY9PA108F6AST1	usd	f	store_01JBYPA7JD468QVY91ZAGTD63M	2024-11-21 19:17:55.868222+00	2024-11-21 19:17:55.868222+00	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.tax_provider (id, is_enabled) FROM stdin;
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01JBYPAG0ZD7ZAHYHJN1F8W1Q6	\N	gb	\N	\N	\N	2024-11-05 17:35:24.192+00	2024-11-05 17:35:24.192+00	\N	\N
txreg_01JBYPAG0Z2CB83GPDS7R26PFP	\N	de	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG0ZWQ2HAPCBQWJT0C28	\N	dk	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG0ZC4K5H76BZJ7E3C7P	\N	se	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG10M678KBBM68NDKPNJ	\N	fr	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG10HBTXA3892RM47HJS	\N	es	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JBYPAG1061HZ57H3DPZPMQAM	\N	it	\N	\N	\N	2024-11-05 17:35:24.193+00	2024-11-05 17:35:24.193+00	\N	\N
txreg_01JD82QV7P8N3JEPM10KCDJQXP	\N	pl	\N	\N	\N	2024-11-21 19:21:16.278+00	2024-11-21 19:21:16.278+00	user_01JC1MRHV9WPHAPYNQAAY41VY2	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01JBYPDPWY9M4V4V7QJ4VA9MWY	\N	\N	lopliok@gmail.com	\N	\N	2024-11-05 17:37:09.534+00	2024-11-05 17:37:09.534+00	\N
user_01JC1M2CNDN7FVRRTTPVZGFMV7	\N	\N	test@gmail.com	\N	\N	2024-11-06 20:53:44.749+00	2024-11-06 20:53:44.75+00	\N
user_01JC1MRHV9WPHAPYNQAAY41VY2	\N	\N	lisan2167@gmail.com	\N	\N	2024-11-06 21:05:50.953+00	2024-11-06 21:05:50.954+00	\N
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: yourusername
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at) FROM stdin;
wf_exec_01JC1NZ2NA2TYKBN1933SXA75Q	complete-cart	cart_01JC1NQ4J2644QFB9G7YBQE3YG	{"state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-query"]}, "_root.use-query": {"id": "_root.use-query", "next": ["_root.use-query.use-remote-query"], "uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928415299, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "action": "use-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928415299, "saveResponse": true}, "_root.use-query.use-remote-query": {"id": "_root.use-query.use-remote-query", "next": ["_root.use-query.use-remote-query.validate-cart-payments"], "uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928416630, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928416630, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments": {"id": "_root.use-query.use-remote-query.validate-cart-payments", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step"], "uuid": "01JC1MVE96XWDW8476NX7T477J", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928421443, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96XWDW8476NX7T477J", "action": "validate-cart-payments", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928421443, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders"], "uuid": "01JC1MVE96AZJS497E7EQBTDVB", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928423286, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96AZJS497E7EQBTDVB", "action": "authorize-payment-session-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928423286, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step", "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step"], "uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928427791, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "action": "create-orders", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928427791, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.update-carts", "next": [], "uuid": "01JC1MVE971X9YMYV376K7K44S", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE971X9YMYV376K7K44S", "action": "update-carts", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage"], "uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "action": "emit-event-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.create-remote-links", "next": [], "uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "action": "create-remote-links", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.reserve-inventory-step", "next": [], "uuid": "01JC1MVE971573931TM0HBS949", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928432297, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE971573931TM0HBS949", "action": "reserve-inventory-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928432297, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage", "next": ["_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39"], "uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "depth": 7, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928435882, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "action": "register-usage", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1730928435882, "saveResponse": true}, "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39": {"id": "_root.use-query.use-remote-query.validate-cart-payments.authorize-payment-session-step.create-orders.emit-event-step.register-usage.when-then-01JC1MVE97GG292XVVPGAE1N39", "next": [], "uuid": "01JC1MVE97SCZWDSGY96584T32", "depth": 8, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1730928437725, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01JC1MVE97SCZWDSGY96584T32", "action": "when-then-01JC1MVE97GG292XVVPGAE1N39", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1730928437725, "saveResponse": true}}, "modelId": "complete-cart", "options": {"name": "complete-cart", "store": true, "idempotent": true, "retentionTime": 259200, "storeExecution": true}, "metadata": {"sourcePath": "/home/liza/projects/personal/flowers_e-commerce/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/complete-cart.js", "eventGroupId": "01JC1NZ225ZJ4VNW8WZEEABEQ3"}, "startedAt": 1730928414070, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01JC1MVE97RXG84HCQGPHRG4VV", "action": "create-remote-links", "noCompensation": false}, {"uuid": "01JC1MVE971X9YMYV376K7K44S", "action": "update-carts", "noCompensation": false}, {"uuid": "01JC1MVE971573931TM0HBS949", "action": "reserve-inventory-step", "noCompensation": false}, {"next": {"next": {"uuid": "01JC1MVE97SCZWDSGY96584T32", "action": "when-then-01JC1MVE97GG292XVVPGAE1N39", "noCompensation": true}, "uuid": "01JC1MVE97TJ5723Y7D16WTMCB", "action": "register-usage", "noCompensation": false}, "uuid": "01JC1MVE97B5F2STXS0BNB4CGD", "action": "emit-event-step", "noCompensation": false}], "uuid": "01JC1MVE96T8BRQ58YSQAEZV43", "action": "create-orders", "noCompensation": false}, "uuid": "01JC1MVE96AZJS497E7EQBTDVB", "action": "authorize-payment-session-step", "noCompensation": false}, "uuid": "01JC1MVE96XWDW8476NX7T477J", "action": "validate-cart-payments", "noCompensation": true}, "uuid": "01JC1MVE96A8XWF8NJW4KRTQGV", "action": "use-remote-query", "noCompensation": true}, "uuid": "01JC1MVE95JCDZGK5RV0KRSE7T", "action": "use-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"use-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": []}, "compensateInput": {"data": []}}}, "update-carts": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:22:33.154Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:13.857Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": "2024-11-06T21:27:12.303Z", "currency_code": "eur", "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}, "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}], "compensateInput": [{"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "completed_at": null}]}}, "create-orders": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}], "compensateInput": ["order_01JC1NZH27XD1DJ2Q134XE9PXC"]}}, "register-usage": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": []}}, "emit-event-step": {"__type": "Symbol(WorkflowWorkflowData)"}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "items": [{"id": "cali_01JC1NQNN7QHZWRC46VSPH20P9", "title": "M / Black", "total": 20, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:22:50.664Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "20", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 20, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}, {"id": "cali_01JC1NSRFMWADF62NXS0VYWTR3", "title": "S / Black", "total": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:23:59.093Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "S / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 40, "region": {"id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "name": "Europe", "metadata": null, "created_at": "2024-11-05T17:35:22.215Z", "deleted_at": null, "updated_at": "2024-11-05T17:35:22.215Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "email": "hml-tester@hml.cz", "phone": null, "metadata": null, "last_name": null, "created_at": "2024-11-06T21:24:45.632Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2024-11-06T21:24:45.632Z", "has_account": false, "company_name": null}, "subtotal": 40, "raw_total": {"value": "40", "precision": 20}, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "tax_total": 0, "created_at": "2024-11-06T21:22:33.154Z", "item_total": 30, "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": null, "raw_subtotal": {"value": "40", "precision": 20}, "currency_code": "eur", "item_subtotal": 30, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 40, "raw_item_total": {"value": "30", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "casm_01JC1NWJ64JXNHWWPZJ29BYWYT", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2024-11-06T21:25:30.948Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:25:36.450Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "30", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "not_paid", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:23.587Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "40", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 30, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 30, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "30", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "30", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}, "compensateInput": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "email": "hml-tester@hml.cz", "items": [{"id": "cali_01JC1NQNN7QHZWRC46VSPH20P9", "title": "M / Black", "total": 20, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:22:50.664Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "20", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 20, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}, {"id": "cali_01JC1NSRFMWADF62NXS0VYWTR3", "title": "S / Black", "total": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "variant": {"id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "product": {"id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ"}, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "location_levels": [{"location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "stock_locations": [{"id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "name": "European Warehouse", "sales_channels": [{"id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "name": "Default Sales Channel"}]}]}], "requires_shipping": true}, "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:23:59.093Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:25:35.155Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "S / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 40, "region": {"id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "name": "Europe", "metadata": null, "created_at": "2024-11-05T17:35:22.215Z", "deleted_at": null, "updated_at": "2024-11-05T17:35:22.215Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "email": "hml-tester@hml.cz", "phone": null, "metadata": null, "last_name": null, "created_at": "2024-11-06T21:24:45.632Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2024-11-06T21:24:45.632Z", "has_account": false, "company_name": null}, "subtotal": 40, "raw_total": {"value": "40", "precision": 20}, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "tax_total": 0, "created_at": "2024-11-06T21:22:33.154Z", "item_total": 30, "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "completed_at": null, "raw_subtotal": {"value": "40", "precision": 20}, "currency_code": "eur", "item_subtotal": 30, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 40, "raw_item_total": {"value": "30", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "deleted_at": null, "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "casm_01JC1NWJ64JXNHWWPZJ29BYWYT", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2024-11-06T21:25:30.948Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:25:36.450Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "30", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "not_paid", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:23.587Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "40", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 30, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 30, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "30", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "30", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}}}, "create-remote-links": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"cart": {"cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}}, {"order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}, "payment": {"payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}], "compensateInput": [{"cart": {"cart_id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}}, {"order": {"order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC"}, "payment": {"payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}]}}, "reserve-inventory-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "resitem_01JC1NZPG7J41K2QGCAXF53RK3", "metadata": null, "quantity": 2, "created_at": "2024-11-06T21:27:13.862Z", "created_by": null, "deleted_at": null, "updated_at": "2024-11-06T21:27:13.862Z", "description": null, "external_id": null, "location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "line_item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "raw_quantity": {"value": "2", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01JBYPBK4SQPXQPEXZJBRG4VPC"}, {"id": "resitem_01JC1NZPG7AB052ZR4CMBT2N17", "metadata": null, "quantity": 1, "created_at": "2024-11-06T21:27:13.862Z", "created_by": null, "deleted_at": null, "updated_at": "2024-11-06T21:27:13.862Z", "description": null, "external_id": null, "location_id": "sloc_01JBYPAGPDXNDTJ03TW9WVFKSV", "line_item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "raw_quantity": {"value": "1", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS"}], "compensateInput": {"reservations": ["resitem_01JC1NZPG7J41K2QGCAXF53RK3", "resitem_01JC1NZPG7AB052ZR4CMBT2N17"], "inventoryItemIds": ["iitem_01JBYPBK4SQPXQPEXZJBRG4VPC", "iitem_01JBYPBK4RN2VEJ1Y8KCAAAPAS"]}}}, "validate-cart-payments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "compensateInput": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "pending", "context": {}, "metadata": null, "created_at": "2024-11-06T21:26:27.753Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:26:28.982Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}]}}, "authorize-payment-session-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "pay_01JC1NZD0TAH7A0SSMYA0MHMCM", "data": {}, "amount": 40, "cart_id": null, "refunds": [], "captures": [], "metadata": null, "order_id": null, "created_at": "2024-11-06T21:27:03.962Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.962Z", "canceled_at": null, "captured_at": null, "customer_id": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_session": {"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "compensateInput": {"id": "pay_01JC1NZD0TAH7A0SSMYA0MHMCM", "data": {}, "amount": 40, "cart_id": null, "refunds": [], "captures": [], "metadata": null, "order_id": null, "created_at": "2024-11-06T21:27:03.962Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.962Z", "canceled_at": null, "captured_at": null, "customer_id": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_session": {"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}, "payment_collection": {"id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27", "amount": 40, "status": "authorized", "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:26:23.587Z", "deleted_at": null, "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:05.184Z", "completed_at": null, "currency_code": "eur", "captured_amount": 0, "refunded_amount": 0, "payment_sessions": [{"id": "payses_01JC1NY9N9KJ1DQ1233AFDZP6B", "data": {}, "amount": 40, "status": "authorized", "context": {}, "created_at": "2024-11-06T21:26:27.753Z", "raw_amount": {"value": "40", "precision": 20}, "updated_at": "2024-11-06T21:27:03.963Z", "provider_id": "pp_system_default", "authorized_at": "2024-11-06T21:27:03.771Z", "currency_code": "eur", "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}], "authorized_amount": 40, "raw_captured_amount": {"value": "0", "precision": 20}, "raw_refunded_amount": {"value": "0", "precision": 20}, "raw_authorized_amount": {"value": "40", "precision": 20}}, "payment_collection_id": "pay_col_01JC1NY5K3RC1BSFF1GVHVFE27"}}}, "when-then-01JC1MVE97GG292XVVPGAE1N39": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}, "compensateInput": {"id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "email": "hml-tester@hml.cz", "items": [{"id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "title": "M / Black", "detail": {"id": "orditem_01JC1NZH29KK3B0D1TZAABWJCH", "item_id": "ordli_01JC1NZH288S4WS3MJ4RG4FP3X", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 2, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "2", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 2, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.105Z", "variant_id": "variant_01JBYPBE916PJQVRTYSQH4HPHN", "adjustments": [], "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "2", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}, {"id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "title": "S / Black", "detail": {"id": "orditem_01JC1NZH299WSNS8KAC57267V5", "item_id": "ordli_01JC1NZH28MV8MKF2EYK723HMN", "version": 1, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "quantity": 1, "created_at": "2024-11-06T21:27:08.106Z", "deleted_at": null, "unit_price": null, "updated_at": "2024-11-06T21:27:08.106Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "Medusa T-Shirt", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "product_id": "prod_01JBYPAX9KTG1VRTK059RV2VWZ", "unit_price": 10, "updated_at": "2024-11-06T21:27:08.106Z", "variant_id": "variant_01JBYPBE90Y0XBX14X6WRTQFRX", "adjustments": [], "variant_sku": "SHIRT-S-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "S / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "difference_sum": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "transaction_total": 0, "pending_difference": 40, "raw_difference_sum": {"value": "0", "precision": 20}, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 40, "original_order_total": 40, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "40", "precision": 20}, "raw_current_order_total": {"value": "40", "precision": 20}, "raw_original_order_total": {"value": "40", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01JBYPADWSXFGTDVY7VEGD8GDQ", "created_at": "2024-11-06T21:27:08.105Z", "deleted_at": null, "display_id": 1, "updated_at": "2024-11-06T21:27:08.105Z", "canceled_at": null, "customer_id": "cus_01JC1NV5Y0KZH5SSZCT7ZRYVHJ", "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "no_notification": false, "sales_channel_id": "sc_01JBYPA6S9ZG068M4VFJQNC33B", "shipping_address": {"id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK", "city": "Praha", "phone": "504010204", "company": "", "metadata": null, "province": "1", "address_1": "Revolucni 10", "address_2": "", "last_name": "tester", "created_at": "2024-11-06T21:24:46.883Z", "first_name": "hml", "updated_at": "2024-11-06T21:24:46.883Z", "customer_id": null, "postal_code": "10610", "country_code": "dk"}, "shipping_methods": [{"id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01JC1NZH27JT2X40VVKXAE01GG", "version": 1, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "updated_at": "2024-11-06T21:27:08.107Z", "shipping_method_id": "ordsm_01JC1NZH27D7CFCR21D8B66RHT"}, "metadata": null, "order_id": "order_01JC1NZH27XD1DJ2Q134XE9PXC", "tax_lines": [], "created_at": "2024-11-06T21:27:08.107Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2024-11-06T21:27:08.107Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01JBYPANQPHC24PMZKPRMX0FRG"}], "billing_address_id": "caaddr_01JC1NV753PR1XC49BZWQE9ACA", "shipping_address_id": "caaddr_01JC1NV753F5WKYSBJXKG8XEPK"}}}}, "payload": {"id": "cart_01JC1NQ4J2644QFB9G7YBQE3YG"}, "compensate": {}}, "errors": []}	done	2024-11-06 21:26:53.354	2024-11-06 21:27:20.232	\N
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 32, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 58, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, false);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, true);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yourusername
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: promotion IDX_promotion_code_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT "IDX_promotion_code_unique" UNIQUE (code);


--
-- Name: workflow_execution PK_workflow_execution_workflow_id_transaction_id; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT "PK_workflow_execution_workflow_id_transaction_id" PRIMARY KEY (workflow_id, transaction_id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_delivery_address_id_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_unique UNIQUE (delivery_address_id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment_method_token payment_method_token_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_method_token
    ADD CONSTRAINT payment_method_token_pkey PRIMARY KEY (id);


--
-- Name: payment payment_payment_session_id_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_session_id_unique UNIQUE (payment_session_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (product_id, image_id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_application_method promotion_application_method_promotion_id_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_unique UNIQUE (promotion_id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_unique UNIQUE (campaign_id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_shipping_option_type_id_unique; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_unique UNIQUE (shipping_option_type_id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_group_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_customer_group_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_provider_id" ON public.fulfillment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- Name: IDX_inventory_item_sku_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku_unique" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_invite_email" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_region_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_collection_region_id" ON public.payment_collection USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_method_token_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_method_token_deleted_at" ON public.payment_method_token USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_price_id_attribute_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_unique" ON public.price_rule USING btree (price_id, attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- Name: IDX_product_image_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_image_deleted_at" ON public.image USING btree (deleted_at);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_code; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_code" ON public.promotion USING btree (code);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_promotion_rule_value_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_rule_promotion_rule_value_id" ON public.promotion_rule_value USING btree (promotion_rule_id);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_option_type_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_shipping_option_type_id" ON public.shipping_option USING btree (shipping_option_type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_user_email" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE UNIQUE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: yourusername
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_coll_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_coll_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_provider_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_provider_id_foreig FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_images product_images_image_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_image_id_foreign FOREIGN KEY (image_id) REFERENCES public.image(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_images product_images_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: yourusername
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

