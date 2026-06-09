#!/usr/bin/env python3
"""
Under Armour E-Commerce Customer Behavior Dataset Generator
===========================================================
Generates 7 tables:
  1. customers.csv
  2. products.csv
  3. transactions.csv
  4. sessions.csv
  5. reviews.csv
  6. experiments.csv
  7. recommendation_events.csv

All columns have correct dtypes.
Nulls are added only to float/object columns — never to int columns.
All NaN-safe operations validated before generation.

Usage:
    python create_dataset.py
"""

from pathlib import Path
import numpy as np
import pandas as pd

# ---------------------------------------------------------------------------
# Reproducibility
# ---------------------------------------------------------------------------
SEED = 42
rng  = np.random.default_rng(SEED)

# ---------------------------------------------------------------------------
# Scale
# ---------------------------------------------------------------------------
N_CUSTOMERS             = 200_000
N_PRODUCTS              = 10_000
N_TRANSACTIONS          = 3_000_000
N_SESSIONS              = 2_000_000
N_REVIEWS               = 500_000
N_EXPERIMENTS           = 400_000
N_RECOMMENDATION_EVENTS = 600_000

DATE_START = pd.Timestamp("2021-01-01")
DATE_END   = pd.Timestamp("2026-02-28")

OUTPUT_DIR = Path(__file__).parent

# ---------------------------------------------------------------------------
# Segments
# ---------------------------------------------------------------------------
SEGMENTS = {
    "UA Rewards Elite":    {"frac": 0.08, "avg_spend": 320, "freq": 3.0,  "churn_prob": 0.04, "loyalty_member": True},
    "UA Rewards Member":   {"frac": 0.22, "avg_spend": 160, "freq": 2.0,  "churn_prob": 0.09, "loyalty_member": True},
    "Performance Athlete": {"frac": 0.20, "avg_spend": 200, "freq": 1.8,  "churn_prob": 0.07, "loyalty_member": False},
    "Casual Buyer":        {"frac": 0.28, "avg_spend": 65,  "freq": 0.7,  "churn_prob": 0.22, "loyalty_member": False},
    "Discount Hunter":     {"frac": 0.15, "avg_spend": 45,  "freq": 0.5,  "churn_prob": 0.32, "loyalty_member": False},
    "One-Time Buyer":      {"frac": 0.07, "avg_spend": 38,  "freq": 0.15, "churn_prob": 0.55, "loyalty_member": False},
}

PRODUCT_CATEGORIES = [
    "Running Shoes","Training Shoes","Basketball Shoes","Football Cleats",
    "Baseball Cleats","Soccer Cleats","Golf Shoes","Hiking Boots",
    "Slides & Sandals","Casual Sneakers","Compression Shirts","T-Shirts & Tops",
    "Hoodies & Sweatshirts","Jackets & Vests","Base Layer Tops","Golf Polos",
    "Shorts","Leggings & Tights","Joggers & Sweatpants","Pants & Chinos",
    "Base Layer Bottoms","Skirts & Skorts","Sports Bras","Underwear","Socks",
    "Backpacks & Bags","Caps & Beanies","Gloves","Headbands & Headwear",
    "Belts & Accessories","Water Bottles & Flasks","Gym Bags & Duffels",
    "Knee Sleeves & Braces","Fitness Trackers",
]

BRANDS = [
    "UA HOVR","UA Charged","UA Flow","UA SlipSpeed","UA Infinite",
    "UA Curry","UA Project Rock","UA Harper","UA Iso-Chill","UA HeatGear",
    "UA ColdGear","UA Storm","UA Rush","UA Rival","UA Armour Fleece",
    "UA Tech","UA Vanish","UA Unstoppable","UA Meridian","UA Machina",
]

COUNTRIES       = ["US","UK","CA","DE","CN","JP","AU","FR","BR","KR"]
COUNTRY_WEIGHTS = [0.45,0.12,0.10,0.08,0.07,0.05,0.04,0.04,0.03,0.02]

GENDERS         = ["M","F","Non-binary","Prefer not to say"]
GENDER_WEIGHTS  = [0.48,0.44,0.04,0.04]

DEVICES         = ["mobile","desktop","tablet"]
DEVICE_WEIGHTS  = [0.52,0.35,0.13]

CHANNELS        = ["organic_search","direct","paid_search","social_media",
                   "email","referral","ua_app"]
CHANNEL_WEIGHTS = [0.28,0.18,0.20,0.15,0.10,0.05,0.04]

PAYMENT_METHODS = ["credit_card","paypal","debit_card","apple_pay",
                   "google_pay","gift_card","afterpay"]
PAYMENT_WEIGHTS = [0.38,0.20,0.18,0.10,0.08,0.04,0.02]

ORDER_STATUSES  = ["completed","completed","completed","completed",
                   "completed","returned","cancelled","pending"]

SPORTS          = ["Running","Training","Basketball","Football",
                   "Golf","Baseball","Soccer","Hiking","General Fitness"]

RECOMMENDATION_MODELS = ["generic","personalized","sport_based","loyalty_based"]

# ---------------------------------------------------------------------------
# Experiments
# ---------------------------------------------------------------------------
EXPERIMENTS = [
    {
        "id":   "EXP001",
        "name": "Personalized vs Generic Homepage Recommendations",
        "goal": "increase_recommendation_ctr",
        "start": pd.Timestamp("2021-03-01"),
        "end":   pd.Timestamp("2021-05-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP002",
        "name": "UA Rewards Loyalty Banner Test",
        "goal": "increase_loyalty_member_conversion",
        "start": pd.Timestamp("2021-11-01"),
        "end":   pd.Timestamp("2021-12-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","loyalty_based"],
    },
    {
        "id":   "EXP003",
        "name": "Sport-Based Recommendation Engine v1",
        "goal": "increase_recommendation_ctr",
        "start": pd.Timestamp("2022-02-01"),
        "end":   pd.Timestamp("2022-04-30"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","sport_based"],
    },
    {
        "id":   "EXP004",
        "name": "New Homepage Layout vs Old Layout",
        "goal": "improve_homepage_conversion",
        "start": pd.Timestamp("2022-08-01"),
        "end":   pd.Timestamp("2022-09-30"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP005",
        "name": "Search Ranking Algorithm A vs B",
        "goal": "improve_search_conversion",
        "start": pd.Timestamp("2023-01-01"),
        "end":   pd.Timestamp("2023-03-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP006",
        "name": "UA Rewards Early Access Personalization",
        "goal": "increase_loyalty_member_retention",
        "start": pd.Timestamp("2023-08-01"),
        "end":   pd.Timestamp("2023-10-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","loyalty_based"],
    },
    {
        "id":   "EXP007",
        "name": "Project Rock Collection Targeted Push",
        "goal": "increase_recommendation_revenue",
        "start": pd.Timestamp("2024-01-01"),
        "end":   pd.Timestamp("2024-03-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","sport_based"],
    },
    {
        "id":   "EXP008",
        "name": "Discount Banner Personalization Test",
        "goal": "reduce_discount_hunter_churn",
        "start": pd.Timestamp("2024-06-01"),
        "end":   pd.Timestamp("2024-08-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP009",
        "name": "Holiday Season Recommendation Engine v2",
        "goal": "increase_holiday_revenue",
        "start": pd.Timestamp("2024-11-01"),
        "end":   pd.Timestamp("2024-12-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP010",
        "name": "Sport Affinity Email Personalization",
        "goal": "improve_email_click_through_rate",
        "start": pd.Timestamp("2025-02-01"),
        "end":   pd.Timestamp("2025-04-30"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","sport_based"],
    },
    {
        "id":   "EXP011",
        "name": "App vs Web Conversion Optimization",
        "goal": "increase_app_conversion_rate",
        "start": pd.Timestamp("2025-06-01"),
        "end":   pd.Timestamp("2025-08-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["generic","personalized"],
    },
    {
        "id":   "EXP012",
        "name": "Loyalty Tier Upgrade Nudge Test",
        "goal": "increase_loyalty_upgrade_rate",
        "start": pd.Timestamp("2025-10-01"),
        "end":   pd.Timestamp("2026-01-31"),
        "variants":  ["control","treatment"],
        "rec_types": ["loyalty_based","personalized"],
    },
]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def random_dates(start, end, n, rng):
    """Generate n random timestamps between start and end."""
    ts_start   = start.value // 10**9
    ts_end     = end.value   // 10**9
    timestamps = rng.integers(ts_start, ts_end, size=n)
    return pd.to_datetime(timestamps, unit="s")


def random_dates_between(start, end, n, rng):
    """Generate n random timestamps between two Timestamps using int conversion."""
    ts_start   = int(start.value // 10**9)
    ts_end     = int(end.value   // 10**9)
    timestamps = rng.integers(ts_start, ts_end, size=n)
    return pd.to_datetime(timestamps, unit="s")


def seasonal_weight(month):
    """Return seasonal multiplier for a given month."""
    return {
        1:1.25, 2:0.75, 3:0.85,  4:0.90,
        5:0.95, 6:0.95, 7:0.85,  8:1.10,
        9:1.15, 10:1.05, 11:1.45, 12:1.55,
    }[month]


def null_out(df, col, pct, rng):
    """
    Set pct fraction of a column to NaN.
    Only call this on float or object columns — never on int columns.
    The column must already be float or object dtype before calling.
    """
    n_nulls = int(pct * len(df))
    if n_nulls == 0:
        return df
    idx = rng.choice(df.index, size=n_nulls, replace=False)
    df.loc[idx, col] = np.nan
    return df


def safe_rating(val, fallback=4.0):
    """
    Return val as float if it is a valid finite number.
    Return fallback if val is NaN, None, or non-finite.
    Used to safely look up product avg_rating which may be NaN.
    """
    try:
        f = float(val)
        if np.isfinite(f):
            return f
        return fallback
    except (TypeError, ValueError):
        return fallback


# ---------------------------------------------------------------------------
# CUSTOMERS
# ---------------------------------------------------------------------------
def generate_customers():
    """
    Generate customers table.
    Integer columns: is_churned, is_loyalty_member, ua_rewards_points,
                     email_opt_in, has_app
    Float columns with nulls: age, lifetime_value
    Object columns with nulls: gender, preferred_sport
    """
    seg_names = list(SEGMENTS.keys())
    seg_fracs = [SEGMENTS[s]["frac"] for s in seg_names]
    segments  = rng.choice(seg_names, size=N_CUSTOMERS, p=seg_fracs)

    # Signup dates — no nulls, all customers have a signup date
    signup_dates = []
    for seg in segments:
        if seg in ("UA Rewards Elite","UA Rewards Member"):
            d = random_dates(pd.Timestamp("2023-07-01"),
                             pd.Timestamp("2025-12-31"), 1, rng)[0]
        elif seg == "Performance Athlete":
            d = random_dates(pd.Timestamp("2019-01-01"),
                             pd.Timestamp("2024-06-30"), 1, rng)[0]
        elif seg == "One-Time Buyer":
            d = random_dates(pd.Timestamp("2024-01-01"),
                             pd.Timestamp("2025-12-31"), 1, rng)[0]
        else:
            d = random_dates(pd.Timestamp("2020-01-01"),
                             pd.Timestamp("2025-06-30"), 1, rng)[0]
        signup_dates.append(d.date())

    # Age — generate as float so NaN can be added later
    ages = rng.normal(26, 9, N_CUSTOMERS).clip(16, 60)
    ages = np.round(ages, 0)  # keep as float64 so NaN is possible

    genders   = rng.choice(GENDERS,   size=N_CUSTOMERS, p=GENDER_WEIGHTS).tolist()
    countries = rng.choice(COUNTRIES, size=N_CUSTOMERS, p=COUNTRY_WEIGHTS)

    # is_churned — int, no nulls
    churn_probs = np.array([SEGMENTS[s]["churn_prob"] for s in segments])
    is_churned  = (rng.random(N_CUSTOMERS) < churn_probs).astype(np.int8)

    # lifetime_value — float so NaN can be added later
    ltv = np.array([
        max(0.0, float(rng.normal(
            SEGMENTS[s]["avg_spend"] * 18,
            SEGMENTS[s]["avg_spend"] * 6
        )))
        for s in segments
    ]).round(2)

    # is_loyalty_member — int, no nulls
    is_loyalty = np.array([
        1 if SEGMENTS[s]["loyalty_member"]
        else int(rng.random() > 0.65)
        for s in segments
    ], dtype=np.int8)

    # ua_rewards_points — int, no nulls (0 for non-members)
    ua_points = np.where(
        is_loyalty == 1,
        rng.integers(100, 15000, N_CUSTOMERS),
        0
    ).astype(np.int32)

    # email_opt_in, has_app — int, no nulls
    email_opt_in = (rng.random(N_CUSTOMERS) > 0.28).astype(np.int8)
    has_app      = (rng.random(N_CUSTOMERS) > 0.38).astype(np.int8)

    # preferred_sport — object so NaN can be added later
    preferred_sport = rng.choice(SPORTS, size=N_CUSTOMERS).tolist()

    df = pd.DataFrame({
        "customer_id":       [f"UA-C{str(i).zfill(6)}" for i in range(N_CUSTOMERS)],
        "signup_date":       signup_dates,
        "age":               ages,              # float64 — nulls added below
        "gender":            genders,           # object  — nulls added below
        "country":           countries,         # object  — no nulls
        "segment":           segments,          # object  — no nulls
        "is_churned":        is_churned,        # int8    — no nulls
        "lifetime_value":    ltv,               # float64 — nulls added below
        "is_loyalty_member": is_loyalty,        # int8    — no nulls
        "ua_rewards_points": ua_points,         # int32   — no nulls
        "email_opt_in":      email_opt_in,      # int8    — no nulls
        "has_app":           has_app,           # int8    — no nulls
        "preferred_sport":   preferred_sport,   # object  — nulls added below
    })

    # Add nulls only to float/object columns
    df = null_out(df, "age",             0.07, rng)
    df = null_out(df, "gender",          0.11, rng)
    df = null_out(df, "lifetime_value",  0.04, rng)
    df = null_out(df, "preferred_sport", 0.09, rng)

    return df


# ---------------------------------------------------------------------------
# PRODUCTS
# ---------------------------------------------------------------------------
def generate_products():
    """
    Generate products table.
    Integer columns: discount_pct, is_featured, is_new_arrival
    Float columns with nulls: avg_rating, num_ratings, stock_quantity
    Float columns no nulls: price, weight_kg
    """
    categories = rng.choice(PRODUCT_CATEGORIES, size=N_PRODUCTS)
    brands     = rng.choice(BRANDS, size=N_PRODUCTS)

    cat_base_price = {
        "Running Shoes":140,"Training Shoes":110,"Basketball Shoes":130,
        "Football Cleats":90,"Baseball Cleats":85,"Soccer Cleats":90,
        "Golf Shoes":120,"Hiking Boots":130,"Slides & Sandals":35,
        "Casual Sneakers":90,"Compression Shirts":55,"T-Shirts & Tops":30,
        "Hoodies & Sweatshirts":70,"Jackets & Vests":130,"Base Layer Tops":50,
        "Golf Polos":65,"Shorts":35,"Leggings & Tights":65,
        "Joggers & Sweatpants":60,"Pants & Chinos":70,"Base Layer Bottoms":50,
        "Skirts & Skorts":45,"Sports Bras":40,"Underwear":18,"Socks":14,
        "Backpacks & Bags":75,"Caps & Beanies":28,"Gloves":35,
        "Headbands & Headwear":18,"Belts & Accessories":25,
        "Water Bottles & Flasks":28,"Gym Bags & Duffels":65,
        "Knee Sleeves & Braces":35,"Fitness Trackers":180,
    }

    # price — float, no nulls
    prices = np.array([
        round(max(9.99, float(rng.lognormal(
            np.log(cat_base_price.get(cat, 60)), 0.25
        ))), 2)
        for cat in categories
    ])

    # avg_rating — float so NaN can be added later
    avg_ratings = np.clip(
        rng.normal(4.2, 0.55, N_PRODUCTS), 1.0, 5.0
    ).round(1)

    # num_ratings — float so NaN can be added later
    num_ratings = rng.integers(0, 8000, N_PRODUCTS).astype(np.float64)

    # stock_quantity — float so NaN can be added later
    stock_quantity = rng.integers(0, 800, N_PRODUCTS).astype(np.float64)

    # discount_pct — int, no nulls
    discount_pct = np.where(
        rng.random(N_PRODUCTS) > 0.70,
        rng.choice([10,15,20,25,30], N_PRODUCTS,
                   p=[0.30,0.25,0.25,0.12,0.08]),
        0
    ).astype(np.int8)

    # is_featured, is_new_arrival — int, no nulls
    is_featured    = (rng.random(N_PRODUCTS) > 0.85).astype(np.int8)
    is_new_arrival = (rng.random(N_PRODUCTS) > 0.80).astype(np.int8)

    # weight_kg — float, no nulls
    weight_kg = np.clip(
        rng.lognormal(0, 0.75, N_PRODUCTS), 0.05, 8
    ).round(2)

    df = pd.DataFrame({
        "product_id":     [f"UA-P{str(i).zfill(4)}" for i in range(N_PRODUCTS)],
        "product_name":   [f"{brands[i]} {categories[i]} #{str(i).zfill(4)}"
                           for i in range(N_PRODUCTS)],
        "category":       categories,        # object  — no nulls
        "brand":          brands,            # object  — no nulls
        "gender_target":  rng.choice(
            ["Men","Women","Unisex","Kids"],
            size=N_PRODUCTS, p=[0.38,0.35,0.20,0.07]
        ),                                   # object  — no nulls
        "price":          prices,            # float64 — no nulls
        "avg_rating":     avg_ratings,       # float64 — nulls added below
        "num_ratings":    num_ratings,       # float64 — nulls added below
        "stock_quantity": stock_quantity,    # float64 — nulls added below
        "discount_pct":   discount_pct,      # int8    — no nulls
        "is_featured":    is_featured,       # int8    — no nulls
        "is_new_arrival": is_new_arrival,    # int8    — no nulls
        "weight_kg":      weight_kg,         # float64 — no nulls
    })

    # Add nulls only to float columns
    df = null_out(df, "avg_rating",    0.08, rng)
    df = null_out(df, "num_ratings",   0.08, rng)
    df = null_out(df, "stock_quantity",0.04, rng)

    return df


# ---------------------------------------------------------------------------
# TRANSACTIONS
# ---------------------------------------------------------------------------
def generate_transactions(customers_df, products_df):
    """
    Generate transactions table.
    Integer columns: quantity
    Float columns with nulls: discount_applied, loyalty_discount, shipping_cost
    Float columns no nulls: unit_price, total_amount
    Object columns no nulls: transaction_id, customer_id, product_id,
                              transaction_date, status, payment_method
    """
    cust_ids       = customers_df["customer_id"].values
    prod_ids       = products_df["product_id"].values
    prod_prices    = products_df.set_index("product_id")["price"].to_dict()
    prod_discounts = products_df.set_index("product_id")["discount_pct"].to_dict()
    cust_segments  = customers_df.set_index("customer_id")["segment"].to_dict()
    cust_loyalty   = customers_df.set_index("customer_id")["is_loyalty_member"].to_dict()

    freq_weights  = np.array([SEGMENTS[cust_segments[c]]["freq"] for c in cust_ids])
    freq_weights /= freq_weights.sum()

    txn_customers = rng.choice(cust_ids, size=N_TRANSACTIONS, p=freq_weights)
    txn_products  = rng.choice(prod_ids, size=N_TRANSACTIONS)
    txn_dates     = random_dates(DATE_START, DATE_END, N_TRANSACTIONS, rng)

    # quantity — int, no nulls
    quantities = np.array([
        max(1, int(rng.exponential(1.4) * seasonal_weight(d.month)))
        for d in txn_dates
    ], dtype=np.int32)

    # Prices — float, no nulls
    base_prices  = np.array([float(prod_prices[p])    for p in txn_products])
    discounts    = np.array([float(prod_discounts[p]) for p in txn_products])

    # loyalty_discount — float (not int) so NaN can be added later
    loyalty_disc_pct = np.array([
        5.0 if cust_loyalty.get(c, 0) == 1 and rng.random() > 0.6
        else 0.0
        for c in txn_customers
    ])

    unit_prices = np.round(
        base_prices * (1.0 - discounts / 100.0) * (1.0 - loyalty_disc_pct / 100.0),
        2
    )
    amounts = np.round(unit_prices * quantities, 2)

    # shipping_cost — float so NaN can be added later
    shipping = np.where(
        amounts >= 60.0,
        0.0,
        np.round(rng.uniform(6.99, 14.99, N_TRANSACTIONS), 2)
    )

    # discount_applied — float so NaN can be added later
    discount_applied = discounts.copy()

    df = pd.DataFrame({
        "transaction_id":    [f"UA-T{str(i).zfill(7)}" for i in range(N_TRANSACTIONS)],
        "customer_id":       txn_customers,
        "product_id":        txn_products,
        "transaction_date":  txn_dates,
        "quantity":          quantities,          # int32   — no nulls
        "unit_price":        unit_prices,         # float64 — no nulls
        "total_amount":      amounts,             # float64 — no nulls
        "discount_applied":  discount_applied,    # float64 — nulls added below
        "loyalty_discount":  loyalty_disc_pct,    # float64 — nulls added below
        "status":            rng.choice(ORDER_STATUSES, size=N_TRANSACTIONS),
        "payment_method":    rng.choice(PAYMENT_METHODS, size=N_TRANSACTIONS,
                                         p=PAYMENT_WEIGHTS),
        "shipping_cost":     shipping,            # float64 — nulls added below
    })

    df = df.sort_values("transaction_date").reset_index(drop=True)
    df["transaction_date"] = df["transaction_date"].dt.strftime("%Y-%m-%d %H:%M:%S")

    # Add nulls only to float columns
    df = null_out(df, "discount_applied", 0.03, rng)
    df = null_out(df, "loyalty_discount", 0.06, rng)
    df = null_out(df, "shipping_cost",    0.05, rng)

    return df


# ---------------------------------------------------------------------------
# SESSIONS
# ---------------------------------------------------------------------------
def generate_sessions(customers_df):
    """
    Generate sessions table.
    Integer columns: converted, bounced, cart_additions, is_loyalty_session
    Float columns with nulls: duration_seconds, pages_viewed
    Object columns with nulls: channel
    """
    cust_ids      = customers_df["customer_id"].values
    cust_segments = customers_df.set_index("customer_id")["segment"].to_dict()
    cust_loyalty  = customers_df.set_index("customer_id")["is_loyalty_member"].to_dict()

    freq_weights  = np.array([SEGMENTS[cust_segments[c]]["freq"] for c in cust_ids])
    freq_weights /= freq_weights.sum()

    sess_customers = rng.choice(cust_ids,  size=N_SESSIONS, p=freq_weights)
    sess_dates     = random_dates(DATE_START, DATE_END, N_SESSIONS, rng)
    devices        = rng.choice(DEVICES,   size=N_SESSIONS, p=DEVICE_WEIGHTS)
    channels       = rng.choice(CHANNELS,  size=N_SESSIONS, p=CHANNEL_WEIGHTS).tolist()

    base_dur_seg = {
        "UA Rewards Elite":720, "UA Rewards Member":480,
        "Performance Athlete":400, "Casual Buyer":220,
        "Discount Hunter":160, "One-Time Buyer":90,
    }
    dev_mult = {"mobile":0.75, "desktop":1.25, "tablet":1.0}

    # duration_seconds and pages_viewed — float so NaN can be added later
    durations    = []
    pages_viewed = []
    for i in range(N_SESSIONS):
        seg = cust_segments[sess_customers[i]]
        dur = float(max(8, int(rng.exponential(
            base_dur_seg[seg] * dev_mult[devices[i]]
        ))))
        durations.append(dur)
        pages_viewed.append(float(max(1, int(dur / rng.uniform(25, 80)))))

    durations    = np.array(durations,    dtype=np.float64)
    pages_viewed = np.array(pages_viewed, dtype=np.float64)

    conv_by_seg = {
        "UA Rewards Elite":0.22, "UA Rewards Member":0.16,
        "Performance Athlete":0.12, "Casual Buyer":0.05,
        "Discount Hunter":0.04, "One-Time Buyer":0.02,
    }
    conv_probs = np.array([conv_by_seg[cust_segments[c]] for c in sess_customers])

    # converted — int, no nulls
    converted = (rng.random(N_SESSIONS) < conv_probs).astype(np.int8)

    # bounced — int, no nulls
    # bounce cannot be 1 if converted is 1
    bounce_base = np.where(np.array(devices) == "mobile", 0.65, 0.55)
    bounced_raw = (rng.random(N_SESSIONS) < bounce_base).astype(np.int8)
    bounced     = np.where(converted == 1, np.int8(0), bounced_raw).astype(np.int8)

    # cart_additions — int, no nulls
    cart_additions = np.where(
        converted == 1,
        rng.integers(1, 6, N_SESSIONS),
        rng.choice([0,0,0,0,1,2], N_SESSIONS)
    ).astype(np.int8)

    # is_loyalty_session — int, no nulls
    is_loyalty_session = np.array([
        int(cust_loyalty.get(c, 0)) for c in sess_customers
    ], dtype=np.int8)

    df = pd.DataFrame({
        "session_id":          [f"UA-S{str(i).zfill(7)}" for i in range(N_SESSIONS)],
        "customer_id":         sess_customers,
        "session_date":        sess_dates,
        "device":              devices,              # object  — no nulls
        "channel":             channels,             # object  — nulls added below
        "duration_seconds":    durations,            # float64 — nulls added below
        "pages_viewed":        pages_viewed,         # float64 — nulls added below
        "converted":           converted,            # int8    — no nulls
        "bounced":             bounced,              # int8    — no nulls
        "cart_additions":      cart_additions,       # int8    — no nulls
        "is_loyalty_session":  is_loyalty_session,   # int8    — no nulls
    })

    df = df.sort_values("session_date").reset_index(drop=True)
    df["session_date"] = df["session_date"].dt.strftime("%Y-%m-%d %H:%M:%S")

    # Add nulls only to float/object columns
    df = null_out(df, "channel",          0.09, rng)
    df = null_out(df, "duration_seconds", 0.06, rng)
    df = null_out(df, "pages_viewed",     0.06, rng)

    return df


# ---------------------------------------------------------------------------
# REVIEWS
# ---------------------------------------------------------------------------
def generate_reviews(customers_df, products_df):
    """
    Generate reviews table.
    Integer columns: rating, verified_purchase
    Float columns with nulls: helpful_votes
    Object columns with nulls: review_text
    Uses safe_rating() to handle NaN avg_rating in products safely.
    """
    cust_ids = customers_df["customer_id"].values
    prod_ids = products_df["product_id"].values

    # Build rating lookup using safe_rating to handle NaN avg_rating
    prod_ratings = {
        pid: safe_rating(val, fallback=4.0)
        for pid, val in
        products_df.set_index("product_id")["avg_rating"].items()
    }

    rev_custs = rng.choice(cust_ids, size=N_REVIEWS)
    rev_prods = rng.choice(prod_ids, size=N_REVIEWS)
    rev_dates = random_dates(DATE_START, DATE_END, N_REVIEWS, rng)

    # rating — int, no nulls
    # safe_rating guarantees no NaN enters rng.normal
    ratings = np.array([
        int(np.clip(
            rng.normal(prod_ratings[pid], 0.9),
            1, 5
        ))
        for pid in rev_prods
    ], dtype=np.int8)

    positive = [
        "Best running shoes I have ever owned. UA HOVR cushioning is absolutely next level.",
        "Project Rock collection is elite. Worth every single penny for the quality.",
        "HeatGear compression keeps me cool even in the most intense summer sessions.",
        "ColdGear kept me perfectly warm during my entire winter marathon training.",
        "Curry 11s are incredible on the court. Best grip and ankle support I have had.",
        "UA Rush leggings are genuinely game-changing. Felt energized the whole workout.",
        "Unstoppable joggers are insanely comfortable. Wearing them every single day.",
        "HOVR Phantom 3 is the best shoe Under Armour has ever released. No competition.",
        "Iso-Chill technology actually delivers. Stayed noticeably cool the whole run.",
        "UA Storm jacket is completely waterproof, super lightweight and packs small.",
        "UA Rewards member perk got me early access to this drop and it was worth it.",
        "Great fit, great material, ships fast. Under Armour quality is always consistent.",
        "The base layer is so good for layering in winter. Warm but not bulky at all.",
        "Charged Cushioning in the training shoes is excellent for heavy lifting sessions.",
        "Bought for my son for football cleats. He absolutely loves them on the field.",
    ]
    neutral = [
        "Decent quality overall but the sizing runs noticeably small. Order one size up.",
        "Good for casual gym sessions but nothing exceptional for serious elite training.",
        "Okay product. Expected slightly more from Under Armour given the price point.",
        "Shipping took longer than expected but the product quality is perfectly fine.",
        "Average performance gear for the price. Does the basic job without standing out.",
        "Quality feels slightly lower compared to older UA products I have owned before.",
        "Fits reasonably well but the colour faded noticeably after just a few washes.",
        "Not bad at all but I have seen similar quality from competitors at lower prices.",
        "The design looks great but comfort is just average for an all-day wear situation.",
        "Works fine for light training sessions but not built for serious performance use.",
    ]
    negative = [
        "Stitching completely came apart after only 3 washes. Very disappointed with this.",
        "Honestly not worth the asking price at all. Nike and Adidas do this much better.",
        "Shoe sole started visibly peeling off after barely 2 months of regular daily use.",
        "Material feels noticeably cheap for such a high price point. Expected much better.",
        "Returned immediately after arrival. Sizing was completely wrong vs the size chart.",
        "Expected significantly better quality from Under Armour. Will not be buying again.",
        "Compression panel completely gave out after the very first use. Terrible QC here.",
        "Colour is nothing at all like the website product photos. Felt genuinely misled.",
        "Customer service was unhelpful when I reported the defect. Very poor experience.",
        "Waistband started rolling down immediately. Useless for any kind of real workout.",
    ]

    # review_text — object so NaN can be added later
    texts = [
        str(rng.choice(positive)) if r >= 4
        else str(rng.choice(neutral)) if r == 3
        else str(rng.choice(negative))
        for r in ratings
    ]

    # helpful_votes — float so NaN can be added later
    helpful_votes = rng.integers(0, 120, N_REVIEWS).astype(np.float64)

    # verified_purchase — int, no nulls
    verified_purchase = (rng.random(N_REVIEWS) > 0.18).astype(np.int8)

    df = pd.DataFrame({
        "review_id":         [f"UA-R{str(i).zfill(6)}" for i in range(N_REVIEWS)],
        "customer_id":       rev_custs,
        "product_id":        rev_prods,
        "review_date":       rev_dates,
        "rating":            ratings,            # int8    — no nulls
        "review_text":       texts,              # object  — nulls added below
        "helpful_votes":     helpful_votes,      # float64 — nulls added below
        "verified_purchase": verified_purchase,  # int8    — no nulls
        "review_source":     rng.choice(
            ["website","mobile_app","post_purchase_email"],
            size=N_REVIEWS, p=[0.45,0.35,0.20]
        ),                                       # object  — no nulls
    })

    df = df.sort_values("review_date").reset_index(drop=True)
    df["review_date"] = df["review_date"].dt.strftime("%Y-%m-%d")

    # Add nulls only to float/object columns
    df = null_out(df, "review_text",   0.22, rng)
    df = null_out(df, "helpful_votes", 0.07, rng)

    return df


# ---------------------------------------------------------------------------
# EXPERIMENTS
# ---------------------------------------------------------------------------
def generate_experiments(customers_df, sessions_df):
    """
    Generate experiments table.
    Integer columns: clicked_recommendation, converted
    Float columns no nulls: revenue
    Object columns with nulls: session_id
    """
    print("  Building experiment exposures...")

    cust_ids      = customers_df["customer_id"].values
    cust_segments = customers_df.set_index("customer_id")["segment"].to_dict()
    cust_loyalty  = customers_df.set_index("customer_id")["is_loyalty_member"].to_dict()
    sess_ids      = sessions_df["session_id"].values

    rows_per_exp = N_EXPERIMENTS // len(EXPERIMENTS)
    all_rows     = []

    for exp in EXPERIMENTS:
        n = rows_per_exp

        # Loyalty experiments oversample loyalty members
        if "loyalty" in exp["goal"].lower():
            loyalty_mask = np.array([
                int(cust_loyalty.get(c, 0)) for c in cust_ids
            ])
            weights  = np.where(loyalty_mask == 1, 3.0, 1.0).astype(np.float64)
            weights /= weights.sum()
            exp_customers = rng.choice(cust_ids, size=n, p=weights)
        else:
            exp_customers = rng.choice(cust_ids, size=n)

        exp_sessions = rng.choice(sess_ids, size=n).tolist()
        exp_dates    = random_dates_between(exp["start"], exp["end"], n, rng)

        # 50/50 control vs treatment
        variants  = rng.choice(exp["variants"], size=n)
        rec_types = np.where(
            variants == "control",
            exp["rec_types"][0],
            exp["rec_types"][1]
        )

        # Treatment outperforms control
        base_ctr            = 0.12
        treatment_lift_ctr  = float(rng.uniform(0.03, 0.08))
        treatment_lift_conv = float(rng.uniform(0.02, 0.06))

        # clicked_recommendation — int, no nulls
        clicked = np.where(
            variants == "treatment",
            (rng.random(n) < (base_ctr + treatment_lift_ctr)).astype(np.int8),
            (rng.random(n) < base_ctr).astype(np.int8)
        ).astype(np.int8)

        # converted — int, no nulls
        base_conv     = 0.05
        converted_exp = np.where(
            variants == "treatment",
            (rng.random(n) < (base_conv + treatment_lift_conv)).astype(np.int8),
            (rng.random(n) < base_conv).astype(np.int8)
        ).astype(np.int8)

        # revenue — float, no nulls (0.0 if not converted)
        seg_avg_spend = np.array([
            float(SEGMENTS[cust_segments[c]]["avg_spend"])
            for c in exp_customers
        ])
        revenue = np.where(
            converted_exp == 1,
            np.round(seg_avg_spend * rng.uniform(0.5, 2.0, n), 2),
            0.0
        ).astype(np.float64)

        chunk = pd.DataFrame({
            "experiment_id":          [exp["id"]]   * n,
            "experiment_name":        [exp["name"]] * n,
            "experiment_goal":        [exp["goal"]] * n,
            "customer_id":            exp_customers,
            "session_id":             exp_sessions,     # object — nulls added below
            "variant":                variants,
            "recommendation_type":    rec_types,
            "exposure_date":          exp_dates,
            "clicked_recommendation": clicked,          # int8   — no nulls
            "converted":              converted_exp,    # int8   — no nulls
            "revenue":                revenue,          # float64 — no nulls
        })
        all_rows.append(chunk)

    df = pd.concat(all_rows, ignore_index=True)
    df = df.sort_values("exposure_date").reset_index(drop=True)
    df["exposure_date"] = df["exposure_date"].dt.strftime("%Y-%m-%d")

    # Add nulls only to object columns
    df = null_out(df, "session_id", 0.04, rng)

    return df


# ---------------------------------------------------------------------------
# RECOMMENDATION EVENTS
# ---------------------------------------------------------------------------
def generate_recommendation_events(customers_df, sessions_df, products_df):
    """
    Generate recommendation_events table.
    Integer columns: impression, clicked, purchased
    Float columns with nulls: revenue
    Object columns with nulls: session_id
    """
    print("  Building recommendation events...")

    cust_ids    = customers_df["customer_id"].values
    sess_ids    = sessions_df["session_id"].values
    prod_ids    = products_df["product_id"].values
    prod_prices = products_df.set_index("product_id")["price"].to_dict()
    cust_loyalty= customers_df.set_index("customer_id")["is_loyalty_member"].to_dict()

    n             = N_RECOMMENDATION_EVENTS
    rec_customers = rng.choice(cust_ids, size=n)
    rec_sessions  = rng.choice(sess_ids, size=n).tolist()
    rec_products  = rng.choice(prod_ids, size=n)
    rec_dates     = random_dates(DATE_START, DATE_END, n, rng)
    rec_models    = rng.choice(
        RECOMMENDATION_MODELS, size=n,
        p=[0.25,0.35,0.25,0.15]
    )

    model_ctr = {
        "generic":       0.08,
        "personalized":  0.18,
        "sport_based":   0.15,
        "loyalty_based": 0.13,
    }

    click_probs = np.array([model_ctr[m] for m in rec_models], dtype=np.float64)
    loyalty_boost = np.array([
        0.03 if int(cust_loyalty.get(c, 0)) == 1 else 0.0
        for c in rec_customers
    ], dtype=np.float64)
    click_probs = np.clip(click_probs + loyalty_boost, 0.0, 1.0)

    # clicked — int, no nulls
    clicked = (rng.random(n) < click_probs).astype(np.int8)

    model_cvr = {
        "generic":       0.04,
        "personalized":  0.10,
        "sport_based":   0.08,
        "loyalty_based": 0.07,
    }
    conv_probs = np.array([model_cvr[m] for m in rec_models], dtype=np.float64)

    # purchased — int, no nulls
    # purchased can only be 1 if clicked is 1
    purchased = np.where(
        clicked == 1,
        (rng.random(n) < conv_probs).astype(np.int8),
        np.int8(0)
    ).astype(np.int8)

    # revenue — float, nulls added below for tracking failures
    base_prices = np.array([float(prod_prices[p]) for p in rec_products])
    revenue     = np.where(
        purchased == 1,
        np.round(base_prices, 2),
        0.0
    ).astype(np.float64)

    # impression — int, always 1 (this table is shown events only)
    impression = np.ones(n, dtype=np.int8)

    df = pd.DataFrame({
        "event_id":             [f"UA-RE{str(i).zfill(7)}" for i in range(n)],
        "customer_id":          rec_customers,
        "session_id":           rec_sessions,    # object  — nulls added below
        "product_id":           rec_products,
        "recommendation_model": rec_models,      # object  — no nulls
        "event_date":           rec_dates,
        "impression":           impression,      # int8    — no nulls
        "clicked":              clicked,         # int8    — no nulls
        "purchased":            purchased,       # int8    — no nulls
        "revenue":              revenue,         # float64 — nulls added below
    })

    df = df.sort_values("event_date").reset_index(drop=True)
    df["event_date"] = df["event_date"].dt.strftime("%Y-%m-%d %H:%M:%S")

    # Add nulls only to float/object columns
    df = null_out(df, "session_id", 0.05, rng)
    df = null_out(df, "revenue",    0.03, rng)

    return df


# ---------------------------------------------------------------------------
# VALIDATION
# ---------------------------------------------------------------------------
def validate_all(tables):
    """
    Run post-generation validation checks.
    Catches any data integrity issues before saving to disk.
    """
    print("\n  Running validation checks...")
    errors   = []
    warnings = []

    customers, products, transactions, sessions, reviews, experiments, rec_events = (
        tables["customers"], tables["products"], tables["transactions"],
        tables["sessions"],  tables["reviews"],  tables["experiments"],
        tables["rec_events"]
    )

    # Check 1 — No nulls in integer columns
    int_cols = {
        "customers":    ["is_churned","is_loyalty_member","ua_rewards_points",
                         "email_opt_in","has_app"],
        "products":     ["discount_pct","is_featured","is_new_arrival"],
        "transactions": ["quantity"],
        "sessions":     ["converted","bounced","cart_additions","is_loyalty_session"],
        "reviews":      ["rating","verified_purchase"],
        "experiments":  ["clicked_recommendation","converted"],
        "rec_events":   ["impression","clicked","purchased"],
    }
    table_map = {
        "customers": customers, "products": products,
        "transactions": transactions, "sessions": sessions,
        "reviews": reviews, "experiments": experiments,
        "rec_events": rec_events,
    }
    for tname, cols in int_cols.items():
        df = table_map[tname]
        for col in cols:
            null_count = df[col].isnull().sum()
            if null_count > 0:
                errors.append(
                    f"  ❌ {tname}.{col} has {null_count} nulls — int column must have no nulls"
                )

    # Check 2 — bounced cannot be 1 when converted is 1
    bad = sessions[(sessions["converted"] == 1) & (sessions["bounced"] == 1)]
    if len(bad) > 0:
        errors.append(f"  ❌ sessions: {len(bad)} rows have converted=1 AND bounced=1")

    # Check 3 — purchased cannot be 1 when clicked is 0
    bad = rec_events[(rec_events["purchased"] == 1) & (rec_events["clicked"] == 0)]
    if len(bad) > 0:
        errors.append(
            f"  ❌ recommendation_events: {len(bad)} rows have purchased=1 AND clicked=0"
        )

    # Check 4 — revenue must be >= 0 where not null
    for tname, col in [("transactions","total_amount"),
                        ("experiments","revenue"),
                        ("rec_events","revenue")]:
        df    = table_map[tname]
        valid = df[col].dropna()
        neg   = (valid < 0).sum()
        if neg > 0:
            errors.append(f"  ❌ {tname}.{col} has {neg} negative values")

    # Check 5 — rating must be 1-5
    bad = reviews[reviews["rating"].notna() &
                  ~reviews["rating"].isin([1,2,3,4,5])]
    if len(bad) > 0:
        errors.append(f"  ❌ reviews.rating has {len(bad)} values outside 1-5")

    # Check 6 — no duplicate primary keys
    pk_checks = [
        ("customers",    "customer_id"),
        ("products",     "product_id"),
        ("transactions", "transaction_id"),
        ("sessions",     "session_id"),
        ("reviews",      "review_id"),
        ("rec_events",   "event_id"),
    ]
    for tname, pk in pk_checks:
        df   = table_map[tname]
        dups = df[pk].duplicated().sum()
        if dups > 0:
            errors.append(f"  ❌ {tname}.{pk} has {dups} duplicate values")

    # Check 7 — date ranges are within bounds
    date_checks = [
        (transactions, "transaction_date"),
        (sessions,     "session_date"),
        (reviews,      "review_date"),
    ]
    for df, col in date_checks:
        dates = pd.to_datetime(df[col])
        if dates.min() < DATE_START:
            warnings.append(
                f"  ⚠️  {col} min date {dates.min()} is before DATE_START"
            )
        if dates.max() > DATE_END:
            warnings.append(
                f"  ⚠️  {col} max date {dates.max()} is after DATE_END"
            )

    # Report
    if errors:
        print("\n  VALIDATION FAILED:")
        for e in errors:
            print(e)
        raise ValueError("Dataset has errors. Fix before saving.")
    else:
        print("  ✅ All validation checks passed")

    if warnings:
        for w in warnings:
            print(w)


# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------
def main():
    print("=" * 60)
    print("Under Armour Ecommerce Dataset Generator")
    print("=" * 60)

    print("\nGenerating customers...")
    customers = generate_customers()

    print("Generating products...")
    products = generate_products()

    print("Generating transactions...")
    transactions = generate_transactions(customers, products)

    print("Generating sessions...")
    sessions = generate_sessions(customers)

    print("Generating reviews...")
    reviews = generate_reviews(customers, products)

    print("Generating experiments...")
    experiments = generate_experiments(customers, sessions)

    print("Generating recommendation events...")
    rec_events = generate_recommendation_events(customers, sessions, products)

    # Run validation before saving anything
    validate_all({
        "customers":    customers,
        "products":     products,
        "transactions": transactions,
        "sessions":     sessions,
        "reviews":      reviews,
        "experiments":  experiments,
        "rec_events":   rec_events,
    })

    print("\nSaving files...")
    customers.to_csv(   OUTPUT_DIR / "customers.csv",             index=False)
    products.to_csv(    OUTPUT_DIR / "products.csv",              index=False)
    sessions.to_csv(    OUTPUT_DIR / "sessions.csv",              index=False)
    reviews.to_csv(     OUTPUT_DIR / "reviews.csv",               index=False)
    experiments.to_csv( OUTPUT_DIR / "experiments.csv",           index=False)
    rec_events.to_csv(  OUTPUT_DIR / "recommendation_events.csv", index=False)
    print("  ✅ customers, products, sessions, reviews, experiments, recommendation_events saved")

    print("  Saving transactions in chunks...")
    chunk_size = 500_000
    total_chunks = (len(transactions) - 1) // chunk_size + 1
    for i, start in enumerate(range(0, len(transactions), chunk_size)):
        chunk  = transactions.iloc[start:start + chunk_size]
        mode   = 'w' if i == 0 else 'a'
        header = i == 0
        chunk.to_csv(
            OUTPUT_DIR / "transactions.csv",
            mode=mode, header=header, index=False
        )
        print(f"    Chunk {i+1}/{total_chunks} written")

    print("\n" + "=" * 60)
    print("FINAL SUMMARY")
    print("=" * 60)

    all_tables = [
        ("customers",             customers),
        ("products",              products),
        ("transactions",          transactions),
        ("sessions",              sessions),
        ("reviews",               reviews),
        ("experiments",           experiments),
        ("recommendation_events", rec_events),
    ]

    total_rows = 0
    for name, df in all_tables:
        nulls     = df.isnull().sum().sum()
        null_pct  = nulls / df.size * 100
        print(f"  {name:<25}: {len(df):>9,} rows x {df.shape[1]:>2} cols "
              f"| nulls: {nulls:>7,} ({null_pct:.1f}%)")
        total_rows += len(df)

    print(f"\n  {'TOTAL ROWS':<25}: {total_rows:>9,}")
    print(f"  {'OUTPUT DIR':<25}: {OUTPUT_DIR}")
    print("=" * 60)


if __name__ == "__main__":
    main()