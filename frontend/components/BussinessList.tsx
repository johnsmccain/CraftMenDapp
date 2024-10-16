import React from "react";
// import { Link } from "react-router-dom";
import { Button } from "./ui/button";
import Image from "next/image";
import Link from "next/link";
import pic1 from "../assets/images/pexels-pixabay-39866.jpg";
const bussinessList = [1, 2, 3, 4, 5, 6, 7, 8, 9];
export const BussinessList = ({ title }: any) => {
	return (
		<div className="mt-5">
			<h2 className="font-bold text-[22px]">{title}</h2>
			<div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mt-5">
				{bussinessList.length > 0
					? bussinessList.map((business, index) => (
							<Link
								href={"/"}
								key={index}
								className="shadow-md rounded-lg hover:shadow-lg cursor-pointer hover:shadow-purple-400 hover:scale-105 transition-all ease-in-out">
								<Image
									src={pic1}
									className="h-[150px] md:h-[200px] object-cover rounded-lg"
									alt=""
									width={500}
									height={200}
								/>
								<div className="flex flex-col items-baseline p-3 gap-1">
									<h2 className="p-1 bg-purple-200 text-purple-500 rounded-full px-2 text-[12px]">
										Plumber
									</h2>
									<h2 className="font-bold text-lg">John Danlami</h2>
									<h2 className="text-purple-600">+234932883443</h2>
									<h2 className="text-gray-500 text-sm">
										N0.21 my house suite, Lagos, Nigeria
									</h2>
									<Button className="rounded-lg mt-3">Book Now</Button>
								</div>
							</Link>
					  ))
					: [1, 2, 3, 4, 5, 6, 7, 8].map((item, index) => (
							<div className="w-[500px] h-[300px] bg-slate-200 rounded-lg animate-pulse"></div>
					  ))}
			</div>
		</div>
	);
};
