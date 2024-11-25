"use client"

import Accordion from "./accordion"

import { HttpTypes } from "@medusajs/types"

import FastDelivery from "@modules/common/icons/fast-delivery"
import Euro from "@modules/common/icons/euro";
import Time from "@modules/common/icons/time";

type ProductTabsProps = {
  product: HttpTypes.StoreProduct
}

const ProductTabs = ({ product }: ProductTabsProps) => {
  const tabs = [
    // {
    //   label: "Product Information",
    //   component: <ProductInfoTab product={product} />,
    // },
    {
      label: "Shipping details",
      component: <ShippingInfoTab />,
    },
  ]

  return (
    <div className="w-full">
      <Accordion type="multiple">
        {tabs.map((tab, i) => (
          <Accordion.Item
            key={i}
            title={tab.label}
            headingSize="medium"
            value={tab.label}
          >
            {tab.component}
          </Accordion.Item>
        ))}
      </Accordion>
    </div>
  )
}

const ProductInfoTab = ({ product }: ProductTabsProps) => {
  return (
    <div className="text-small-regular py-8">
      <div className="grid grid-cols-2 gap-x-8">
        <div className="flex flex-col gap-y-4">
          <div>
            <span className="font-semibold">Material</span>
            <p>{product.material ? product.material : "-"}</p>
          </div>
          <div>
            <span className="font-semibold">Country of origin</span>
            <p>{product.origin_country ? product.origin_country : "-"}</p>
          </div>
          <div>
            <span className="font-semibold">Type</span>
            <p>{product.type ? product.type.value : "-"}</p>
          </div>
        </div>
        <div className="flex flex-col gap-y-4">
          <div>
            <span className="font-semibold">Weight</span>
            <p>{product.weight ? `${product.weight} g` : "-"}</p>
          </div>
          <div>
            <span className="font-semibold">Dimensions</span>
            <p>
              {product.length && product.width && product.height
                ? `${product.length}L x ${product.width}W x ${product.height}H`
                : "-"}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

const ShippingInfoTab = () => {
  return (
    <div className="text-small-regular py-8">
      <div className="grid grid-cols-1 gap-y-8">
        <div className="flex items-start gap-x-2">
          <FastDelivery />
          <div>
            <span className="font-semibold">Fast delivery</span>
            <p className="max-w-sm">
              After ordering a bouquet, it takes just few hours and the bouquet is delivered right to the recipient´s hands.
              You can add a notice about the desired delivery time. Please make sure that the recipient of the bouquet is at the place of delivery and your surprise will be perfect.
            </p>
          </div>
        </div>
        <div className="flex items-start gap-x-2">
          <Euro />
          <div>
            <span className="font-semibold">Delivery costs</span>
            <ul className="max-w-sm">
              <li>working days delivery: €10</li>
              <li>delivery on Saturday, Sunday: €12</li>
              <li>redelivery (in the case of recipient absence): €10</li>
            </ul>
          </div>
        </div>
        <div className="flex items-start gap-x-2">
          <Time />
          <div>
            <span className="font-semibold">Delivery times of bouquets</span>
            <ul className="max-w-sm">
              <li>on weekdays between 7.00 - 20.00</li>
              <li>on Saturday and Sunday between 9.00 - 20.00</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductTabs
