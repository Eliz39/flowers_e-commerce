import { Button, Heading } from "@medusajs/ui"
import Image from "next/image"
import heroImage from './flower-shop.jpg'

const Hero = () => {
  return (
    <div className="h-[75vh] w-full border-b border-ui-border-base relative bg-ui-bg-subtle">
      <div className="absolute inset-0 z-10 flex flex-col justify-center items-center text-center small:p-32 gap-6">
        <span>
          <Heading
            level="h1"
            className="text-3xl leading-10 text-ui-fg-base font-normal bg-rose-50 text-rose-900 px-2"
          >
            Make every day special with Boutique Camellia
          </Heading>
        </span>
        <a
          href="/store"
        >
          <Button variant="secondary" size="xlarge" className="bg-rose-900 text-white p-4 uppercase hover:bg-rose-500 border-rose-900">
            view flowers
          </Button>
        </a>
      </div>
      <Image
          src={heroImage}
          fill
          loading="eager"
          priority={true}
          quality={65}
          alt="flower-shop"
          className="absolute inset-0"
          draggable="false"
          style={{objectFit: "cover"}}
      />
    </div>
  )
}

export default Hero
