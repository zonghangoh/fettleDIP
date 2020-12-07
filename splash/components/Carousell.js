import React, { Component } from 'react'
import { tns } from 'tiny-slider/src/tiny-slider.module'

export default class Carousel extends Component {
    constructor(props) {
        super(props)
        this.sliderContainer = React.createRef()
    }

    componentDidMount() {
        this.slider = tns({
            ...this.props,
            container: this.sliderContainer.current,
        })

    }

    componentWillUnmount() {
        if (this.slider) {
            this.slider.destroy()
        }
    }

    goToSlide = index => {
        this.slider.goTo(index)
    }

    render() {
        return (
            <div ref={this.sliderContainer}>
                {React.Children.map(this.props.children, (child, index) =>
                    React.cloneElement(child, { onClick: () => this.goToSlide(index) })
                )}
            </div>
        )
    }
}